--T·F Shockwave
function c50218209.initial_effect(c)
    --pos
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_POSITION)
    e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c50218209.poscon)
    e1:SetOperation(c50218209.posop)
    c:RegisterEffect(e1)
    --summon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,50218209)
    e2:SetCondition(c50218209.cona)
    e2:SetCost(c50218209.cost)
    e2:SetTarget(c50218209.tg)
    e2:SetOperation(c50218209.op)
    c:RegisterEffect(e2)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e3:SetCountLimit(1)
    e3:SetCondition(c50218209.cond)
    e3:SetValue(c50218209.valcon)
    c:RegisterEffect(e3)
end
function c50218209.poscon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsAttackPos()
end
function c50218209.posop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsAttackPos() then
        Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
    end
end
function c50218209.cona(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsDisabled() and e:GetHandler():IsAttackPos()
end
function c50218209.cond(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():IsDisabled() and e:GetHandler():IsDefensePos()
end
function c50218209.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,800) end
    Duel.PayLPCost(tp,800)
end
function c50218209.filter(c,e,tp)
    return c:IsSetCard(0xcb2) and c:IsType(TYPE_MONSTER) and c:IsSummonable(true,nil)
end
function c50218209.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c50218209.filter,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c50218209.op(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
    local g=Duel.SelectMatchingCard(tp,c50218209.filter,tp,LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.Summon(tp,tc,true,nil)
    end
end
function c50218209.valcon(e,re,r,rp)
    return bit.band(r,REASON_EFFECT)~=0
end