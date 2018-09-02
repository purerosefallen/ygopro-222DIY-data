--D·T·F Megatron
function c50218218.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcb2),3,3)
    c:EnableReviveLimit()
    --indes
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --pos
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(50218218,0))
    e2:SetCategory(CATEGORY_POSITION)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
    e2:SetCountLimit(1)
    e2:SetCondition(c50218218.poscon)
    e2:SetTarget(c50218218.postg)
    e2:SetOperation(c50218218.posop)
    c:RegisterEffect(e2)
    --disable spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(50218218,1))
    e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_SPSUMMON)
    e3:SetCountLimit(1,50218218)
    e3:SetCondition(c50218218.condition)
    e3:SetTarget(c50218218.target)
    e3:SetOperation(c50218218.operation)
    c:RegisterEffect(e3)
    --activate limit
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e4:SetCode(EVENT_CHAINING)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c50218218.cond)
    e4:SetOperation(c50218218.aclimit1)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e5:SetCode(EVENT_CHAIN_NEGATED)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c50218218.cond)
    e5:SetOperation(c50218218.aclimit2)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_CANNOT_ACTIVATE)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(0,1)
    e6:SetCondition(c50218218.econ)
    e6:SetValue(c50218218.elimit)
    c:RegisterEffect(e6)
end
function c50218218.poscon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c50218218.postg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c50218218.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
    end
end
function c50218218.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp~=ep and Duel.GetCurrentChain()==0 and e:GetHandler():IsAttackPos()
end
function c50218218.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c50218218.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateSummon(eg)
    Duel.Destroy(eg,REASON_EFFECT)
end
function c50218218.cond(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsDefensePos()
end
function c50218218.aclimit1(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
    e:GetHandler():RegisterFlagEffect(50218218,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c50218218.aclimit2(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
    e:GetHandler():ResetFlagEffect(50218218)
end
function c50218218.econ(e)
    return e:GetHandler():GetFlagEffect(50218218)~=0 and e:GetHandler():IsDefensePos()
end
function c50218218.elimit(e,te,tp)
    return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end