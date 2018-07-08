--数码兽超进化-徽章
function c50218127.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,50218127+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c50218127.cost)
    e1:SetTarget(c50218127.target)
    e1:SetOperation(c50218127.activate)
    c:RegisterEffect(e1)
    --destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetTarget(c50218127.reptg)
    e2:SetValue(c50218127.repval)
    e2:SetOperation(c50218127.repop)
    c:RegisterEffect(e2)
end
function c50218127.costfilter(c,e,tp)
    if not c:IsSetCard(0xcb1) or not c:IsAbleToGraveAsCost() or not c:IsFaceup() then return false end
    local code=c:GetCode()
    local class=_G["c"..code]
    if class==nil or class.lvupcount==nil then return false end
    return Duel.IsExistingMatchingCard(c50218127.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,class,e,tp)
end
function c50218127.spfilter(c,class,e,tp)
    local code=c:GetCode()
    for i=1,class.lvupcount do
        if code==class.lvup[i] then return c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
    end
    return false
end
function c50218127.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50218127.costfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c50218127.costfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SendtoGrave(g,REASON_COST)
    e:SetLabel(g:GetFirst():GetCode())
end
function c50218127.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c50218127.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local code=e:GetLabel()
    local class=_G["c"..code]
    if class==nil or class.lvupcount==nil then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c50218127.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,class,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
        if tc:GetPreviousLocation()==LOCATION_DECK then Duel.ShuffleDeck(tp) end
    end
end
function c50218127.repfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0xcb1) and c:IsLocation(LOCATION_MZONE)
        and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c50218127.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c50218127.repfilter,1,nil,tp) end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c50218127.repval(e,c)
    return c50218127.repfilter(c,e:GetHandlerPlayer())
end
function c50218127.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
