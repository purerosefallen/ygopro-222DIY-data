--原初兽封印之地 万魔殿
local m=47511102
local cm=_G["c"..m]
function c47511102.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c47511102.accost)
    e1:SetTarget(c47511102.tetg)
    e1:SetOperation(c47511102.teop)
    c:RegisterEffect(e1) 
    --disable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetTarget(c47511102.disable)
    e2:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e2)
    --reborn
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetTarget(c47511102.tdtg) 
    e3:SetOperation(c47511102.tdop)
    c:RegisterEffect(e3)
    --
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCost(c47511102.rmcost)
    e4:SetTarget(c47511102.rmtg) 
    e4:SetOperation(c47511102.rmop)
    c:RegisterEffect(e4)
    --
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetRange(LOCATION_FZONE)
    e5:SetCode(EVENT_LEAVE_FIELD)
    e5:SetCondition(c47511102.spcon)
    e5:SetTarget(c47511102.sptg)
    e5:SetOperation(c47511102.spop)
    e5:SetLabelObject(sg)
    c:RegisterEffect(e5)
    --maintai
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1)
    e5:SetCondition(c47511102.mtcon)
    e5:SetOperation(c47511102.mtop)
    c:RegisterEffect(e5) 
end
function c47511102.cfilter(c)
    return c:IsSetCard(0x5de) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c47511102.accost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c47511102.cfilter,tp,LOCATION_DECK,0,nil)
    if chk==0 then return g:GetClassCount(Card.GetCode)>=4 end
    local rg=Group.CreateGroup()
    for i=1,4 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local tc=g:Select(tp,1,1,nil):GetFirst()
        if tc then
            rg:AddCard(tc)
            g:Remove(Card.IsCode,nil,tc:GetCode())
        end
    end
    Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
end
function c47511102.mtcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c47511102.mtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.SelectMatchingCard(tp,c47511102.cfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
    else
        Duel.Destroy(e:GetHandler(),REASON_COST)
    end
end
function c47511102.tefil(c)
    return c:IsSetCard(0x5da) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c47511102.tefil2(c,code)
    return c:IsSetCard(0x5da) and c:IsType(TYPE_MONSTER) and not c:IsCode(code) and c:IsAbleToHand()
end
function c47511102.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47511102.tefil,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end

function c47511102.teop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,c47511102.tefil,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
            local tc=g:GetFirst()
            local code=tc:GetCode()
            local g2=Duel.SelectMatchingCard(tp,c47511102.tefil2,tp,LOCATION_DECK,0,1,1,nil,code)
            if g2:GetCount()>0 then
                g:Merge(g2)
            end
            Duel.SendtoExtraP(g,tp,REASON_EFFECT)
        end
end
function c47511102.disable(e,c)
   return c:IsSummonType(SUMMON_TYPE_SPECIAL) and not c:IsPreviousLocation(LOCATION_EXTRA)
end
function c47511102.filter2(c,tp)
    return c:IsFaceup() and c:IsAbleToDeck()
end
function c47511102.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c47511102.filter2,1,nil,tp) end
    local g=eg:Filter(c47511102.filter2,nil,tp)
    Duel.SetTargetCard(eg)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c47511102.tdop(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(c47511102.filter2,nil,tp)
    if g:GetCount()>0 then
        Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    end
end
function c47511102.costfilter(c)
    return c:IsSetCard(0x5da) and c:IsAbleToDeckAsCost()
end
function c47511102.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47511102.costfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c47511102.costfilter,tp,LOCATION_REMOVED,0,1,1,e:GetHandler())
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c47511102.spfilter2(c,e,tp)
    return c:IsSetCard(0x5df) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c47511102.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0 and Duel.IsExistingMatchingCard(c47511102.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c47511102.rmop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47511102.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP) 
    end
end
function c47511102.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetReasonPlayer()==1-tp 
end
function c47511102.spfilter(c,e,tp)
    return (c:IsSetCard(0x5de) or c:IsSetCard(0x5da)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47511102.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c47511102.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local tg=Duel.GetMatchingGroup(c47511102.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
    if ft<=0 or tg:GetCount()==0 then return end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=tg:Select(tp,ft,ft,nil)
    local tc=g:GetFirst()
    while tc do
         Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)      
    end
end