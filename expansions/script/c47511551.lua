--zai？出来丢人
function c47511551.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,c47511551.lcheck)
    c:EnableReviveLimit()
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47511551,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,47511551)
    e1:SetCondition(c47511551.hspcon)
    e1:SetTarget(c47511551.hsptg)
    e1:SetOperation(c47511551.hspop)
    c:RegisterEffect(e1)  
    --coin result
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47511551,0))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c47511551.coincon1)
    e3:SetOperation(c47511551.coinop1)
    c:RegisterEffect(e3)  
end
c47511551.toss_coin=true
function c47511551.lcheck(g,lc)
    return g:IsExists(c47511551.lfilter,1,nil)
end
function c47511551.lfilter(c)
    return c.toss_coin and c:IsType(TYPE_MONSTER)
end
function c47511551.hspcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47511551.hspfilter(c,e,tp)
    return c.toss_coin and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c47511551.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47511551.hspfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c47511551.hspop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47511551.hspfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
    end
end
function c47511551.coincon1(e,tp,eg,ep,ev,re,r,rp)
    local ex,eg,et,cp,ct=Duel.GetOperationInfo(ev,CATEGORY_COIN)
    if ex then
        e:SetLabelObject(re)
        return true
    else return false end
end
function c47511551.coinop1(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_TOSS_COIN_NEGATE)
    e1:SetCountLimit(1)
    e1:SetCondition(c47511551.coincon2)
    e1:SetOperation(c47511551.coinop2)
    e1:SetLabelObject(e:GetLabelObject())
    e1:SetReset(RESET_CHAIN)
    Duel.RegisterEffect(e1,tp)
end
function c47511551.coincon2(e,tp,eg,ep,ev,re,r,rp)
    return re==e:GetLabelObject()
end
function c47511551.coinop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,47511551)
    local res={Duel.GetCoinResult()}
    local ct=ev
    for i=1,ct do
        res[i]=1
    end
    Duel.SetCoinResult(table.unpack(res))
end