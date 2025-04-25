module("luci.controller.admin.network-test", package.seeall)

function index()
    entry({"admin", "network", "network_test"}, template("network-test"), _("IP段批量测速"), 60).dependent = false
    entry({"admin", "network", "network_test", "run"}, call("action_run")).leaf = true
end

function action_run()
    local http = require "luci.http"
    local sys = require "luci.sys"
    local util = require "luci.util"
    
    -- 初始化响应
    http.prepare_content("application/json")
    
    -- 获取参数
    local ip_start = http.formvalue("ip_start") or ""
    local ip_end = http.formvalue("ip_end") or ""
    
    -- 验证IP格式
    local function is_valid_ip(ip)
        local chunks = {ip:match("^(%d+)%.(%d+)%.(%d+)%.(%d+)$")}
        if #chunks ~= 4 then return false end
        for _, v in ipairs(chunks) do
            local num = tonumber(v)
            if not num or num < 0 or num > 255 then
                return false
            end
        end
        return true
    end
    
    if not is_valid_ip(ip_start) or not is_valid_ip(ip_end) then
        return http.write_json({error = "Invalid IP format"})
    end
    
    -- 生成IP范围
    local function ip_to_num(ip)
        local num = 0
        for d in ip:gmatch("%d+") do
            num = num * 256 + tonumber(d)
        end
        return num
    end
    
    local start_num = ip_to_num(ip_start)
    local end_num = ip_to_num(ip_end)
    
    if start_num > end_num then
        return http.write_json({error = "Start IP must be less than End IP"})
    end
    
    if (end_num - start_num) > 255 then
        return http.write_json({error = "Maximum 256 IPs allowed"})
    end
    
    -- 执行Ping测试
    local results = {}
    for n = start_num, end_num do
        local ip = string.format("%d.%d.%d.%d",
            math.floor(n / 16777216) % 256,
            math.floor(n / 65536) % 256,
            math.floor(n / 256) % 256,
            n % 256)
        
        local output = util.exec(string.format("fping -e -c 1 -t 1000 %q 2>&1", ip))
        local latency = output:match("min/avg/max = ([%d%.]+)/")
        
        table.insert(results, {
            ip = ip,
            latency = latency and tonumber(latency),
            status = latency and "reachable" or "unreachable"
        })
    end
    
    -- 排序结果：可达的优先，按延迟排序
    table.sort(results, function(a, b)
        if a.latency and not b.latency then return true end
        if not a.latency and b.latency then return false end
        if a.latency and b.latency then return a.latency < b.latency end
        return a.ip < b.ip
    end)
    
    http.write_json(results)
end

-- 兼容性处理（OpenWrt 21.02+）
if not luci.sys or not luci.sys.exec then
    local util = require "luci.util"
    luci.sys = luci.sys or { exec = util.exec }
end
