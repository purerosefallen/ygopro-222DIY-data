--没有你的完美世界
function c5012606.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c5012606.cost)
    e1:SetTarget(c5012606.target)
    e1:SetOperation(c5012606.activate)
    c:RegisterEffect(e1)
    --sp
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(5012606,0))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,5012606)
    e2:SetCost(c5012606.recost)
    e2:SetTarget(c5012606.tg)
    e2:SetOperation(c5012606.op)
    c:RegisterEffect(e2)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetCode(EFFECT_ADD_SETCODE)
    e4:SetValue(0x250)
    c:RegisterEffect(e4)
end
function c5012606.filter(c,e,tp)
    return c:IsSetCard(0x250) and c:IsAbleToRemoveAsCost() and Duel.GetLocationCountFromEx(tp,tp,c)>0 and Duel.IsExistingMatchingCard(c5012606.filter2,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,5,c) and c:IsFaceup()
end
function c5012606.filter2(c)
    return c:IsSetCard(0x250) and c:IsAbleToRemoveAsCost() and c:IsFaceup() and c:IsFaceup()
end
function c5012606.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c5012606.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g1=Duel.SelectMatchingCard(tp,c5012606.filter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil,e,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local sg=g1:Clone()
    sg:AddCard(c)
    local g2=Duel.SelectMatchingCard(tp,c5012606.filter2,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,5,5,sg,e,tp)
    g1:Merge(g2)
    Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c5012606.spfilter(c,e,tp)
    return c:IsSetCard(0x250) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsFacedown()
end
function c5012606.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c5012606.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c5012606.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCountFromEx(tp)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sp=Duel.GetMatchingGroup(c5012606.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
    local g=sp:RandomSelect(tp,1)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)~=0 then
       tc:CompleteProcedure()
       if tc:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(5012606,0)) then
          Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
          local tg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,1,2,nil)
          Duel.Overlay(tc,tg)
       end
    end
end
function c5012606.recost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c5012606.defilter(c)
    return c:IsAbleToDeck() and c:IsSetCard(0x250) and c:IsFaceup()
end
function c5012606.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c5012606.defilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c5012606.thfilter(c)
    return c:IsAbleToHand() and c:IsSetCard(0x250) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c5012606.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.GetMatchingGroup(c5012606.defilter,tp,LOCATION_GRAVE,0,nil)
    local tg=g:Select(tp,1,g:GetCount(),nil)
    if tg:GetCount()>0 and  Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)>0 
    and  Duel.IsExistingMatchingCard(c5012606.thfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(5012606,1)) then 
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sp=Duel.SelectMatchingCard(tp,c5012606.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
    if sp:GetCount()>0 then
    Duel.SendtoHand(sp,nil,REASON_EFFECT)
    end
end
end