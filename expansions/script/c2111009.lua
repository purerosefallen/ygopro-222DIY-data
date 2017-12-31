--三位一体的女神
local m=2111009
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x218),3)
    --indes
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetCondition(c2111009.indcon)
    e4:SetRange(LOCATION_MZONE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --immune
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCode(EFFECT_IMMUNE_EFFECT)
    e6:SetCondition(c2111009.indcon)
    e6:SetValue(c2111009.efilter)
    c:RegisterEffect(e6)
    --discard deck
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetCategory(CATEGORY_RECOVER+CATEGORY_REMOVE)
    e1:SetDescription(aux.Stringid(2111009,0))
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetTarget(c2111009.target)
    e1:SetOperation(c2111009.operation)
    c:RegisterEffect(e1)
    --draw
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(2111009,2))
    e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e7:SetCode(EVENT_TO_GRAVE)
    e7:SetCountLimit(1,2111009)
    e7:SetCondition(c2111009.drcon)
    e7:SetTarget(c2111009.drtg)
    e7:SetOperation(c2111009.drop)
    c:RegisterEffect(e7)
end
function c2111009.indcon(e)
    local c=e:GetHandler()
    return c:GetLinkedGroupCount()==0
end
function c2111009.efilter(e,te)
    return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c2111009.filter2(c,tp)
    return c:IsFaceup() and c:GetControler()==1-tp and c:IsAbleToRemove()
end
function c2111009.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c2111009.filter2,1,nil,tp) end
    local g=eg:Filter(c2111009.filter2,nil,tp)
    Duel.SetTargetCard(eg)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c2111009.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=eg:Filter(c2111009.filter2,nil,tp)
    if g:GetCount()>0 then
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        Duel.Recover(tp,500,REASON_EFFECT)
    end
end
function c2111009.drcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c2111009.filter(c,e,tp)
    return c:IsSetCard(0x218) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c2111009.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c2111009.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c2111009.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c2111009.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c2111009.drop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
                tc:CopyEffect(2111009,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
        end 
    end
end