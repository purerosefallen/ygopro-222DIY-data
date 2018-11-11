--卡斯巴尔专用高达
local m=47530025
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --synchro summon
    aux.AddSynchroMixProcedure(c,c47530025.matfilter1,nil,nil,aux.NonTuner(c47530025.matfilter2),1,99)  
    --atkup
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e0:SetCode(EVENT_BATTLE_DESTROYING)
    e0:SetCondition(aux.bdocon)
    e0:SetOperation(c47530025.atkop)
    c:RegisterEffect(e0)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47530025.psplimit)
    c:RegisterEffect(e1)     
    --indes
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c47530025.inmcon)
    e2:SetValue(1)
    c:RegisterEffect(e2) 
    local e3=e2:Clone()
    e3:SetCode(EFFECT_EXTRA_ATTACK)
    c:RegisterEffect(e3)
    --rank1
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47530025,1))
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c47530025.r1con)
    e4:SetValue(1500)
    c:RegisterEffect(e4)  
    --actlimit
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_FIELD)
    e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e9:SetCode(EFFECT_CANNOT_ACTIVATE)
    e9:SetRange(LOCATION_MZONE)
    e9:SetTargetRange(0,1)
    e9:SetValue(c47530025.aclimit)
    e9:SetCondition(c47530025.actcon)
    c:RegisterEffect(e9)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47530025,0))
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c47530025.r3con)
    e5:SetValue(c47530025.efilter)
    c:RegisterEffect(e5)  
    --rank2
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(47530025,1))
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e6:SetCode(EVENT_BATTLE_DAMAGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(c47530025.r2con)
    e6:SetOperation(c47530025.caop)
    c:RegisterEffect(e6)
    --rank3
    local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(47530025,2))
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetCode(EFFECT_DIRECT_ATTACK)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c47530025.r3con)
    c:RegisterEffect(e7)
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(47530025,2))
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e8:SetCode(EVENT_BATTLE_END)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCondition(c47530025.r3conb)
    e8:SetOperation(c47530025.dtop)
    c:RegisterEffect(e8)
end
function c47530025.psplimit(e,c)
    return not c:IsRace(RACE_MACHINE)
end
function c47530025.matfilter1(c)
    return c:IsType(TYPE_TUNER) and c:IsRace(RACE_MACHINE)
end
function c47530025.matfilter2(c)
    return c:IsRace(RACE_MACHINE)
end
function c47530025.inmcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47530025.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c47530025.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c47530025.actcon(e)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler() and e:GetHandler():GetFlagEffect(47530025)>=1 
end
function c47530025.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
    c:RegisterFlagEffect(47530025,RESET_EVENT+0x7e0000,0,1)    
end
function c47530025.r1con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(47530025)>=1 
end
function c47530025.r2con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(47530025)>=2 
end
function c47530025.r3con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(47530025)>=3
end
function c47530025.r3conb(e,tp,eg,ep,ev,re,r,rp)
   return e:GetHandler():GetFlagEffect(47530025)>=3 and Duel.GetBattleDamage(1-tp)==0
end
function c47530025.caop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChainAttack()
end
function c47530025.dtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local atk=c:GetBaseAttack()
    local lp=Duel.GetLP(1-tp)
    Duel.SetLP(1-tp,lp-atk) 
end