--打破束缚的伟大之翼 原初巴哈姆特
local m=47510084
local cm=_G["c"..m]
function c47510084.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddFusionProcMix(c,false,true,c47510084.fusfilter1,c47510084.fusfilter2,c47510084.fusfilter3,c47510084.fusfilter4)
    aux.EnablePendulumAttribute(c,false) 
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.fuslimit)
    c:RegisterEffect(e1)   
    --immune effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_IMMUNE_EFFECT)
    e2:SetRange(LOCATION_PZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c47510084.etarget)
    e2:SetValue(c47510084.efilter)
    c:RegisterEffect(e2)
    --disable spsummon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47510084,0))
    e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_SPSUMMON)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCondition(c47510084.condition)
    e3:SetTarget(c47510084.target)
    e3:SetOperation(c47510084.operation)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SUMMON)
    c:RegisterEffect(e4)
    --cannot release
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CANNOT_RELEASE)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(1,1)
    e5:SetTarget(c47510084.rellimit)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    c:RegisterEffect(e7)
    local e8=e6:Clone()
    e8:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    c:RegisterEffect(e8)
    local e9=e6:Clone()
    e9:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    c:RegisterEffect(e9)  
    --summon success
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e10:SetCode(EVENT_SPSUMMON_SUCCESS)
    e10:SetCondition(c47510084.sumcon)
    e10:SetOperation(c47510084.sumsuc)
    c:RegisterEffect(e10)
    --immune
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetCode(EFFECT_IMMUNE_EFFECT)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetValue(c47510084.efilter1)
    c:RegisterEffect(e11)
    --cannot remove
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_SINGLE)
    e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e12:SetCode(EFFECT_CANNOT_REMOVE)
    e12:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e12)
    --the great end
    local e13=Effect.CreateEffect(c)
    e13:SetCategory(CATEGORY_REMOVE)
    e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e13:SetCode(EVENT_BATTLE_START)
    e13:SetCondition(c47510084.rmcon)
    e13:SetOperation(c47510084.rmop)
    c:RegisterEffect(e13)
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e14:SetCode(EVENT_LEAVE_FIELD)
    e14:SetProperty(EFFECT_FLAG_DELAY)
    e14:SetCondition(c47510084.pencon)
    e14:SetTarget(c47510084.pentg)
    e14:SetOperation(c47510084.penop)
    c:RegisterEffect(e14)
    --control
    local e15=Effect.CreateEffect(c)
    e15:SetType(EFFECT_TYPE_SINGLE)
    e15:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e15:SetRange(LOCATION_MZONE)
    e15:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
    c:RegisterEffect(e15)
end
function c47510084.efilter1(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c47510084.rellimit(e,c,tp,sumtp)
    return c==e:GetHandler()
end
function c47510084.fusfilter1(c)
    return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsFusionType(TYPE_FUSION)
end
function c47510084.fusfilter2(c)
    return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFusionType(TYPE_SYNCHRO)
end
function c47510084.fusfilter3(c)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsFusionType(TYPE_XYZ)
end
function c47510084.fusfilter4(c)
    return c:IsAttribute(ATTRIBUTE_WATER) and c:IsFusionType(TYPE_LINK)
end
function c47510084.etarget(e,c)
    return c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_LINK) or c:IsType(TYPE_LINK)
end
function c47510084.efilter(e,re)
    return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c47510084.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp~=ep and Duel.GetCurrentChain()==0
end
function c47510084.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c47510084.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateSummon(eg)
    Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
end
function c47510084.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c47510084.sumsuc(e,tp,eg,ep,ev,re,r,rp)    
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(0,1)
    e1:SetValue(c47510084.actlimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    Duel.Hint(HINT_MUSIC,0,aux.Stringid(47510084,0))    
end
function c47510084.actlimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c47510084.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsRelateToBattle()
end
function c47510084.rmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,e:GetHandler())
    if sg:GetCount()>0 then
        Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
    end
end
function c47510084.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47510084.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47510084.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end