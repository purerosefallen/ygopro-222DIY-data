--T·F The Last Knight
function c50218224.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_POSITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EVENT_BE_BATTLE_TARGET)
    e2:SetCountLimit(1,50218224)
    e2:SetCondition(c50218224.condition)
    e2:SetTarget(c50218224.target)
    e2:SetOperation(c50218224.activate)
    c:RegisterEffect(e2)
end
function c50218224.condition(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetAttackTarget()
    return d:IsControler(tp) and d:IsFaceup() and d:IsSetCard(0xcb2)
end
function c50218224.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local ta=Duel.GetAttacker()
    local td=Duel.GetAttackTarget()
    if chkc then return chkc==ta end
    if chk==0 then return ta:IsOnField() and ta:IsCanBeEffectTarget(e)
        and td:IsOnField() and td:IsCanBeEffectTarget(e) end
    local g=Group.FromCards(ta,td)
    Duel.SetTargetCard(g)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,td,1,0,0)
end
function c50218224.activate(e,tp,eg,ep,ev,re,r,rp)
    local ta=Duel.GetAttacker()
    local td=Duel.GetAttackTarget()
    if ta:IsRelateToEffect(e) and Duel.NegateAttack() and td:IsFaceup() and td:IsRelateToEffect(e) then
        Duel.ChangePosition(td,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
    end
end