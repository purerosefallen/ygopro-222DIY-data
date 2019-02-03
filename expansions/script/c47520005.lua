--西的守护神 玛琪拉
local m=47520005
local cm=_G["c"..m]
function c47520005.initial_effect(c)
    c:EnableReviveLimit()
    c:EnableCounterPermit(0x5d8)
    c:SetCounterLimit(0x5d8,3)
    --material
    c:EnableReviveLimit() 
    aux.AddXyzProcedureLevelFree(c,c47520005.mfilter,c47520005.xyzcheck,2,2,c47520005.ovfilter,aux.Stringid(47520005,0),2,c47520005.xyzop)
    aux.EnablePendulumAttribute(c,false)  
    --boost
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetCondition(c47520005.ctcon1)
    e1:SetValue(500)
    c:RegisterEffect(e1)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetCondition(c47520005.ctcon2)
    e5:SetValue(1000)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e6)
    local e7=e5:Clone()
    e7:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
    e7:SetValue(1)
    c:RegisterEffect(e7)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_BATTLE_DAMAGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c47520005.ctcon3)
    e4:SetOperation(c47520005.damop)
    c:RegisterEffect(e4)    
    --def down
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLE_START)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c47520005.dbcon)
    e2:SetOperation(c47520005.dbop)
    c:RegisterEffect(e2)
    --koon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47520005,0))
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetCondition(c47520005.cocon)
    e3:SetTarget(c47520005.target)
    e3:SetOperation(c47520005.opd1)
    c:RegisterEffect(e3)
end
function c47520005.ovfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_BEASTWARRIOR) and c:IsType(TYPE_XYZ) and not c:IsCode(47520005)
end
function c47520005.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,47520005)==0 end
    Duel.RegisterFlagEffect(tp,47520005,RESET_PHASE+PHASE_END,0,1)
end
function c47520005.mfilter(c)
    return c:IsLevel(8)
end
function c47520005.xyzcheck(g)
    return g:IsExists(Card.IsRace,1,nil,RACE_BEASTWARRIOR) or g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_EARTH)
end
function c47520005.cocon(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttacker()
    return at:IsControler(tp) and (at:IsRace(RACE_BEASTWARRIOR) or at:IsAttribute(ATTRIBUTE_EARTH))
end
function c47520005.target(e,tp,eg,ep,ev,re,r,rp,chk)   
    Duel.SetChainLimit(aux.FALSE)
end
function c47520005.opd1(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x5d8,1)
    end
end
function c47520005.dbcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetAttacker()
    if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
    return tc and tc:IsControler(tp) and tc:IsAttribute(ATTRIBUTE_EARTH)
end
function c47520005.dbop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttackTarget()
    if not tc then return end
    if tc:IsControler(tp) then tc=Duel.GetAttacker() end
    c:CreateRelation(tc,RESET_EVENT+RESETS_STANDARD)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_DISABLE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
    tc:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DISABLE_EFFECT)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
    tc:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetValue(-1850)
    e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
    tc:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_UPDATE_DEFENSE)
    tc:RegisterEffect(e4)
end
function c47520005.ctcon1(e,c)
    return c:GetCounter(0x5d8)>=1
end
function c47520005.ctcon2(e,c)
    return c:GetCounter(0x5d8)>=2
end
function c47520005.ctcon3(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return ep~=tp and eg:GetFirst():GetControler()==tp and c:GetCounter(0x5d8)>=3
end
function c47520005.damop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local atk=c:GetAttack()/2
    Duel.Damage(1-tp,atk,REASON_EFFECT)
end