--阿卡鲁姆的转世 审判
local m=47510215
local cm=_G["c"..m]
function c47510215.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --pendulum effect
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510215,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47510215)
    e1:SetCost(c47510215.mcost)
    e1:SetTarget(c47510215.mtg)
    e1:SetOperation(c47510215.mop)
    c:RegisterEffect(e1)
    --splimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e2:SetRange(LOCATION_PZONE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c47510215.splimit)
    c:RegisterEffect(e2) 
    --Summon
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_SUMMON)
    e3:SetDescription(aux.Stringid(47510215,1))
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1,47510200)
    e3:SetCost(c47510215.scost)
    e3:SetTarget(c47510215.stg)
    e3:SetOperation(c47510215.sop)
    c:RegisterEffect(e3)  
    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47510215,1))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetOperation(c47510215.sumop)
    c:RegisterEffect(e4)
    --indes
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetRange(LOCATION_EXTRA)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND))
    e5:SetValue(500)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e6) 
end
function c47510215.splimit(e,c)
    return not c:IsAttribute(ATTRIBUTE_WIND)
end
function c47510215.mcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler() and Duel.CheckLPCost(tp,2000) end
    Duel.SendtoExtraP(e:GetHandler(),nil,0,REASON_COST)
    Duel.PayLPCost(tp,2000)
end
function c47510215.spfilter(c,e,tp)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47510215.mtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47510215.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c47510215.mop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47510215.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
        e1:SetValue(LOCATION_REMOVED)
        tc:RegisterEffect(e1,true)
        Duel.SpecialSummonComplete()
    end
end
function c47510215.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(tp,2000,REASON_EFFECT)
end
function c47510215.scost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,nil,ATTRIBUTE_WIND) end
    local g=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,nil,ATTRIBUTE_WIND)
    Duel.Release(g,REASON_COST)
end
function c47510215.ttcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c47510215.stg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
        e1:SetCondition(c47510215.ttcon)
        c:RegisterEffect(e1)
        local res=c:IsSummonable(true,nil) or c:IsAbleToGrave()
        e1:Reset()
        return res
    end
end
function c47510215.sop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetCondition(c47510215.ttcon)
    c:RegisterEffect(e1)
    if c:IsSummonable(true,nil) then
    Duel.Summon(tp,c,true,nil)
    end
end
function c47510215.sumop(e,tp,eg,ep,ev,re,r,rp)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetCondition(c47510215.actcon)
    e2:SetOperation(c47510215.disop)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND))
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetValue(1)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47510215.actcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetAttacker()
    if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
    return tc and tc:IsControler(tp) and tc:IsAttribute(ATTRIBUTE_WIND)
end
function c47510215.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttackTarget()
    if not tc then return end
    if tc:IsControler(tp) then tc=Duel.GetAttacker() end
    c:CreateRelation(tc,RESET_EVENT+RESETS_STANDARD)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetCondition(c47510215.discon2)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    e2:SetCondition(c47510215.discon2)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    tc:RegisterEffect(e2)
end
function c47510215.discon2(e)
    return e:GetOwner():IsRelateToCard(e:GetHandler())
end
function c47510215.atktg(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND)
end