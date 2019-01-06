--泳装的圣少女 贞德
local m=47598775
local cm=_G["c"..m]
function c47598775.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_MONSTER),2,3,c47598775.lcheck)
    c:EnableReviveLimit() 
    --检索
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47598775,1))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c47598775.thtg)
    e1:SetOperation(c47598775.thop)
    c:RegisterEffect(e1)
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47598775,2))
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetTarget(c47598775.indtg)
    e2:SetOperation(c47598775.indop)
    c:RegisterEffect(e2)
    --atk,defdown
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,LOCATION_MZONE)
    e3:SetValue(c47598775.atkval)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e4)
end
function c47598775.filter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c47598775.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47598775.filter,tp,0,LOCATION_GRAVE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c47598775.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47598775.filter,tp,0,LOCATION_GRAVE,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47598775.lcheck(g)
    return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT) or g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WIND)
end
function c47598775.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c47598775.indop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
        tc:RegisterEffect(e2)
        local e4=e1:Clone()
        e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
        tc:RegisterEffect(e4)
    end
end
function c47598775.atkval(e)
    return Duel.GetMatchingGroupCount(Card.IsAttribute,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil,ATTRIBUTE_WIND)*-300
end