--觉醒的圣少女 贞德
local m=47598774
local cm=_G["c"..m]
function c47598774.initial_effect(c)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --synchro summon
    aux.AddSynchroProcedure(c,c47598774.synfilter2,aux.NonTuner(c47598774.synfilter),1)
    c:EnableReviveLimit()
    --splimit
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetRange(LOCATION_PZONE)
    e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e0:SetTargetRange(1,0)
    e0:SetTarget(c47598774.psplimit)
    c:RegisterEffect(e0)
    --Negate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47598774,0))
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,47598774)
    e1:SetCondition(c47598774.discon)
    e1:SetCost(c47598774.discost)
    e1:SetTarget(c47598774.distg)
    e1:SetOperation(c47598774.disop)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47598774,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCondition(c47598774.spcon)
    e2:SetTarget(c47598774.sptg)
    e2:SetOperation(c47598774.spop)
    c:RegisterEffect(e2)
    --salvage
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47598774,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCondition(c47598774.thcon)
    e3:SetTarget(c47598774.sumtg)
    e3:SetOperation(c47598774.sumop)
    c:RegisterEffect(e3)
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_MATERIAL_CHECK)
    e0:SetValue(c47598774.valcheck)
    e0:SetLabelObject(e3)
    c:RegisterEffect(e0)
    --damage&recover
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47598774,3))
    e4:SetCategory(CATEGORY_RECOVER)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_BATTLE_DESTROYING)
    e4:SetTarget(c47598774.damtg)
    e4:SetOperation(c47598774.damop)
    c:RegisterEffect(e4)
    --actlimit
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetCode(EFFECT_CANNOT_ACTIVATE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(0,1)
    e5:SetValue(c47598774.aclimit)
    c:RegisterEffect(e5)
    --disable
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_DISABLE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(LOCATION_SZONE,1)
    e6:SetTarget(c47598774.distg)
    c:RegisterEffect(e6)
    --pendulum
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(47598774,4))
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e7:SetCode(EVENT_DESTROYED)
    e7:SetProperty(EFFECT_FLAG_DELAY)
    e7:SetCondition(c47598774.pencon)
    e7:SetTarget(c47598774.pentg)
    e7:SetOperation(c47598774.penop)
    c:RegisterEffect(e7)
end
function c47598774.psplimit(e,c,tp,sumtp,sumpos)
    return not c:IsRace(RACE_FAIRY) and bit.band(sumtp,SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL 
end
function c47598774.synfilter(c)
    return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_SYNCHRO)
end
function c47598774.synfilter2(c)
    return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_NORMAL)
end
function c47598774.costfilter(c)
    return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToGraveAsCost()
end
function c47598774.discon(e,tp,eg,ep,ev,re,r,rp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c47598774.distg(e,c)
    return c:IsType(TYPE_TRAP)
end
function c47598774.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToGraveAsCost() and 
        Duel.IsExistingMatchingCard(c47598774.costfilter,tp,LOCATION_HAND,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47598774.costfilter,tp,LOCATION_HAND,0,1,1,c)
    Duel.SendtoGrave(g,REASON_COST)
end
function c47598774.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c47598774.disop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function c47598774.cfilter(c,tp)
    return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c47598774.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47598774.cfilter,1,nil,tp)
end
function c47598774.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47598774.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c47598774.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47598774.mfilter(c)
    return c:IsCode(47598771)
end
function c47598774.filter(c,e,sp)
    return c:IsRace(RACE_WARRIOR) and c:IsLevelBelow(3) and  c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c47598774.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47598774.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c47598774.sumop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local tg=Duel.GetMatchingGroup(c47598774.filter,tp,LOCATION_DECK,0,nil,e,tp)
    if ft<=0 or tg:GetCount()==0 then return end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=tg:Select(tp,ft,ft,nil)
    local c=e:GetHandler()
    local tc=g:GetFirst()
    while tc do
        Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e3)
        tc=g:GetNext()
    end
    Duel.SpecialSummonComplete()
end
function c47598774.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetAttackTarget()~=nil end
    local c=e:GetHandler()
    local d=Duel.GetAttackTarget()
    if d==c then d=Duel.GetAttacker() end
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,d:GetAttack())
end
function c47598774.damop(e,tp,eg,ep,ev,re,r,rp)
    local ex2,a2,b2,p2,d2=Duel.GetOperationInfo(0,CATEGORY_RECOVER)
    Duel.Recover(tp,d2,REASON_EFFECT,true)
    Duel.RDComplete()
end
function c47598774.aclimit(e,re,tp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsType(TYPE_TRAP)
end
function c47598774.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47598774.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47598774.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end