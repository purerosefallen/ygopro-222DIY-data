--星晶兽融合体 维拉=修瓦利耶
local m=47510092
local cm=_G["c"..m]
function c47510092.initial_effect(c)
    c:EnableCounterPermit(0x5dc)
    c:SetCounterLimit(0x5dc,1)
    --cannot attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(c47510092.antg)
    e1:SetValue(-c:GetAttack())
    c:RegisterEffect(e1)    
    --cannot attack
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetTarget(c47510092.antg)
    c:RegisterEffect(e2) 
    --damage reduce
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CHANGE_DAMAGE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(1,0)
    e3:SetValue(c47510092.damval)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
    c:RegisterEffect(e4)
    --back
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e9:SetCode(EVENT_ADJUST)
    e9:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
    e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
    e9:SetCondition(c47510092.backon)
    e9:SetOperation(c47510092.backop)
    c:RegisterEffect(e9)
end
function c47510092.damval(e,re,val,r,rp,rc)
    if bit.band(r,REASON_EFFECT)~=0 or bit.band(r,REASON_BATTLE)~=0 then
        e:GetHandler():AddCounter(0x5dc,1)
        return 0
    end
    return val
end
function c47510092.antg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c47510092.backon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c.dfc_front_side and c:GetOriginalCode()==c.dfc_back_side
end
function c47510092.backop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tcode=c.dfc_front_side
    c:SetEntityCode(tcode)
    Duel.ConfirmCards(tp,Group.FromCards(c))
    Duel.ConfirmCards(1-tp,Group.FromCards(c))
    c:ReplaceEffect(tcode,0,0)
end
function c47510092.repfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsOnField() and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c47510092.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c47510092.repfilter,1,e:GetHandler(),tp) end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c47510092.repval(e,c)
    return c47510092.repfilter(c,e:GetHandlerPlayer())
end
function c47510092.repop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RemoveCounter(tp,0x5dc,1,REASON_EFFECT)
end