--精奥的造物
local m=80000006
local cm=_G["c"..m]
cm.afkind=6
cm.is_named_with_yvwan=1
cm.is_named_with_artifact=1
xpcall(function() require("expansions/script/c80000000") end,function() require("script/c80000000") end)
function cm.initial_effect(c)
    --back
    Sym.afback(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetOperation(cm.spreg)
    c:RegisterEffect(e1)
end
function cm.spreg(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD) then
        c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
    end
end