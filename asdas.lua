if shared.ran then return end

shared.ran = true -- we love less spam

local http_request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local url = "https://api.counterapi.dev/v2/triocantgetmes-team-1882/first-counter-1882/up"

local response = http_request({
    Method = "GET",
    Url = url,
})

