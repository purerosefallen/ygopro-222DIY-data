--辉夜姬
local m=47590011
local cm=_G["c"..m]
function c47590011.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,nil,2,5,c47590011.lcheck)
    c:EnableReviveLimit()
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.linklimit)
    c:RegisterEffect(e1)
    --drop
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47590011,0))
    e1:SetCategory(CATEGORY_COUNTER)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,47590011)
    e1:SetCondition(c47590011.ctcon)
    e1:SetTarget(c47590011.cttg)
    e1:SetOperation(c47590011.ctop)
    c:RegisterEffect(e1)
    --atk down
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,LOCATION_MZONE)
    e2:SetValue(c47590011.atkval)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47590011,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,47590012)
    e3:SetOperation(c47590011.operation)
    c:RegisterEffect(e3)
end
function c47590011.lcheck(g)
    return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end
function c47590011.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47590011.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c47590011.ctop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
    local tc=g:GetFirst()
    while tc do
        if not tc:IsCanAddCounter(0x105d,4) then
            tc:EnableCounterPermit(0x105d)
        end
        tc:AddCounter(0x105d,4)
    end
end
function c47590011.atkval(e,c)
    return Duel.GetCounter(0,1,1,0x105d)*-300
end
function c47590011.filter(c,e,tp,id)
    return c:IsReason(REASON_DESTROY) and c:GetTurnID()==id and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end
function c47590011.operation(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
    e1:SetCountLimit(1)
    e1:SetOperation(c47590011.spop)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47590011.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local tg=Duel.GetMatchingGroup(c47590011.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e,tp,Duel.GetTurnCount())
    if ft<=0 then return end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    local g=nil
    if tg:GetCount()>ft then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        g=tg:Select(tp,ft,ft,nil)
    else
        g=tg
    end
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end