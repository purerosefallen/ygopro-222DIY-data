--天司圣域—迦南
local m=47578930
local cm=_G["c"..m]
function c47578930.initial_effect(c)
        --activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(c47578930.activate)
    c:RegisterEffect(e1)
    --attribute
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
    e2:SetValue(ATTRIBUTE_LIGHT)
    c:RegisterEffect(e2)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCountLimit(1+47578930)
    e2:SetTarget(c47578930.sptg)
    e2:SetOperation(c47578930.spop)
    c:RegisterEffect(e2)
end
function c47578930.thf(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5de) and c:IsAbleToHand()
end
function c47578930.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c47578930.thf,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(47578930,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function c47578930.tfilter(c,att,e,tp)
    return c:IsSetCard(0x5de) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not c:IsCode(47590008)
end
function c47578930.filter(c,e,tp)
    return c:IsFaceup() and Duel.IsExistingMatchingCard(c47578930.tfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute(),e,tp)
end
function c47578930.chkfilter(c,att)
    return c:IsFaceup() and c:IsAttribute(att)
end
function c47578930.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_PZONE) and c47578930.chkfilter(chkc,e:GetLabel()) end
    if chk==0 then return Duel.IsExistingTarget(c47578930.filter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
    local g=Duel.SelectTarget(tp,c47578930.filter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    e:SetLabel(g:GetFirst():GetAttribute())
end
function c47578930.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    local att=tc:GetAttribute()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    Duel.Destroy(tc,REASON_EFFECT)
    local sg=Duel.SelectMatchingCard(tp,c47578930.tfilter,tp,LOCATION_DECK,0,1,1,nil,att,e,tp)
    if sg:GetCount()>0 then
        Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
        sg:GetFirst():CompleteProcedure()
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47578930.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47578930.splimit(e,c)
    return not c:IsRace(RACE_FAIRY) and c:IsLocation(LOCATION_EXTRA)
end