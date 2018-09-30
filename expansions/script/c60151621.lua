--破碎的命运
function c60151621.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,60151621+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c60151621.target)
    e1:SetOperation(c60151621.activate)
    c:RegisterEffect(e1)
end
function c60151621.filter(c,tp)
    local lv=c:GetLevel()
    return c:IsFaceup() and c:IsSetCard(0xcb25) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_XYZ) 
        and Duel.IsExistingMatchingCard(c60151621.pcfilter,tp,LOCATION_DECK,0,1,nil,lv)
end
function c60151621.pcfilter(c,lv)
    return c:IsSetCard(0xcb25) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:GetLevel()==lv
end
function c60151621.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c60151621.filter,tp,LOCATION_MZONE,0,1,nil,tp) 
        and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    Duel.SelectTarget(tp,c60151621.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c60151621.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local lv=tc:GetLevel()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Destroy(tc,REASON_EFFECT)
        local ct=0
        if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ct=ct+1 end
        if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct=ct+1 end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local g=Duel.SelectMatchingCard(tp,c60151621.pcfilter,tp,LOCATION_DECK,0,1,ct,nil,lv)
        local pc=g:GetFirst()
        while pc do
            Duel.MoveToField(pc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
            pc=g:GetNext()
        end
    end
end
function c60151621.rdcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end
function c60151621.rdop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,ev/2)
end