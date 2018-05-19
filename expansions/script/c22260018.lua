--紫阳花与梅雨与忧郁的他
local m=22260018
local cm=_G["c"..m]
function cm.initial_effect(c)
    --token
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(22260018,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,222600181)
    e1:SetTarget(c22260018.target)
    e1:SetOperation(c22260018.activate)
    c:RegisterEffect(e1)
    --SpecialSummon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,222600182)
    e2:SetCondition(c22260018.sprcon)
    c:RegisterEffect(e2)
    --SendtoGrave
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(22260018,2))
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_TO_HAND)
    e3:SetCountLimit(1)
    e3:SetCondition(c22260018.sgcon)
    e3:SetTarget(c22260018.sgtg)
    e3:SetOperation(c22260018.sgop)
    c:RegisterEffect(e3)
end

function c22260018.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
       and Duel.IsPlayerCanSpecialSummonMonster(tp,22269996,nil,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    end
function c22260018.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,22269996,nil,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_EARTH) then
    local token=Duel.CreateToken(tp,22269996)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
    end
end

function c22260018.sprfilter2(c)
    return c:IsFaceup() and c:IsRace(RACE_PLANT)
end
function c22260018.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local ft=Duel.GetMZoneCount(tp)
    local ct2=Duel.GetMatchingGroupCount(c22260018.sprfilter2,tp,LOCATION_MZONE,0,nil)
    return ft>0 and ct2>0
end
    
function c22260018.cfilter(c,tp)
    return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and not c:IsReason(REASON_DRAW)
end
function c22260018.sgcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c22260018.cfilter,1,nil,1-tp)
end
function c22260018.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:GetCount()>0 end
    Duel.SetTargetCard(eg)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,eg,eg:GetCount(),1-tp,0)
end
function c22260018.filter(c,e,tp)
    return c:IsRelateToEffect(e) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c22260018.sgop(e,tp,eg,ep,ev,re,r,rp)
    local sg=eg:Filter(c22260018.filter,nil,e,1-tp)
    if sg:GetCount()>0 then
        Duel.SendtoGrave(sg,REASON_EFFECT)
    end
end