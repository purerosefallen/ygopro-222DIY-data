--六曜的牙月丘儿
function c12001024.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xfba),c12001024.ffilter,true)
    --special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c12001024.spcon)
    e1:SetOperation(c12001024.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(12001024,0))
    e2:SetCategory(CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1,12001024+EFFECT_COUNT_CODE_DUEL)
    e2:SetTarget(c12001024.settg)
    e2:SetOperation(c12001024.setop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(12001024,1))
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCode(EVENT_CHAINING)
    e3:SetCountLimit(1,12001124)
    e3:SetCondition(c12001024.discon)
    e3:SetTarget(c12001024.distg)
    e3:SetOperation(c12001024.disop)
    c:RegisterEffect(e3)
end
function c12001024.matfilter(c)
    return c:IsSetCard(0xfb0) and c:IsReleasable() and c:IsFaceup()
end
function c12001024.cfilter1(c,tp,g)
    return c:IsFaceup()
end
function c12001024.spfilter(c,fc)
    return c12001024.matfilter(c) and c:IsCanBeFusionMaterial(fc)
end
function c12001024.spfilter1(c,tp,g)
    return g:IsExists(c12001024.spfilter2,1,c,tp,c)
end
function c12001024.spfilter2(c,tp,mc)
    return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c12001024.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetReleaseGroup(tp):Filter(c12001024.spfilter,nil,c)
    return g:IsExists(c12001024.spfilter1,1,nil,tp,g)
end
function c12001024.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetReleaseGroup(tp):Filter(c12001024.spfilter,nil,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=g:FilterSelect(tp,c12001024.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=g:FilterSelect(tp,c12001024.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    c:SetMaterial(g1)
    Duel.Release(g1,REASON_COST+REASON_FUSION+REASON_MATERIAL)
end
function c12001024.filter(c)
    return c:IsSetCard(0xfb0) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c12001024.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c12001024.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c12001024.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,c12001024.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SSet(tp,g:GetFirst())
        Duel.ConfirmCards(1-tp,g)
    end
end
function c12001024.discon(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
        and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c12001024.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c12001024.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
        Duel.Destroy(c,REASON_EFFECT)
    end
end
