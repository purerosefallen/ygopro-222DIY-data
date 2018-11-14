--娜露梅亚-源氏舞
local m=47510225
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=m+2
function c47510225.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --xyz summon
    c:EnableReviveLimit()
    aux.AddXyzProcedure(c,c47510225.mfilter,8,2)  
    --Change
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510225,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(c47510225.changetg)
    e1:SetOperation(c47510225.changeop)
    c:RegisterEffect(e1)  
    --da
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47510225,1))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c47510225.dacon)
    e2:SetTarget(c47510225.datg)
    e2:SetOperation(c47510225.daop)
    c:RegisterEffect(e2) 
    --slow
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47510225,2))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetCondition(c47510225.dacon)
    e3:SetOperation(c47510225.slop)
    c:RegisterEffect(e3) 
    --de
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47510225,3))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCost(c47510225.cost)
    e4:SetCondition(c47510225.dacon)
    e4:SetTarget(c47510225.datg)
    e4:SetOperation(c47510225.deop)
    c:RegisterEffect(e4)  
    local e6=Effect.CreateEffect(c)
    e6:SetCategory(CATEGORY_ATKCHANGE)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e6:SetCode(EVENT_ATTACK_ANNOUNCE)
    e6:SetCondition(c47510225.atkcon)
    e6:SetTarget(c47510225.atktg)
    e6:SetOperation(c47510225.atkop)
    c:RegisterEffect(e6)
    --battle indes
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e5:SetCountLimit(1)
    e5:SetValue(c47510225.valcon)
    c:RegisterEffect(e5)    
end
c47510225.pendulum_level=8
function c47510225.mfilter(c,xyzc)
    return c:IsType(TYPE_PENDULUM)
end
function c47510225.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c.dfc_back_side and c.dfc_front_side==c:GetOriginalCode() end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c47510225.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
    local tcode=c.dfc_back_side
    c:SetEntityCode(tcode,true)
    if c:ReplaceEffect(tcode,0,0) then   
    c:RegisterFlagEffect(47510227,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
    c:RegisterFlagEffect(47510226,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
    end
end
function c47510225.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetBattleTarget()
    return tc and tc:IsFaceup() and tc:GetAttack()>0 and e:GetHandler():GetFlagEffect(47510226)~=0
end
function c47510225.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return true end
    e:GetHandler():GetBattleTarget():CreateEffectRelation(e)
end
function c47510225.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=c:GetBattleTarget()
    if not c:IsRelateToEffect(e) or c:IsFacedown() or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local atk=tc:GetAttack()
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_ATTACK)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e2:SetValue(math.ceil(atk/2))
        c:RegisterEffect(e2)
        if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            e1:SetValue(math.ceil(atk/2))
            tc:RegisterEffect(e1)
        end
    end
end
function c47510225.dacon(e)
    return e:GetHandler():GetFlagEffect(47510225)==0
end
function c47510225.datg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c47510225.daop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
    c:RegisterFlagEffect(47510225,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c47510225.slop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetRange(LOCATION_ONFIELD)
    e2:SetTargetRange(0,1)
    e2:SetValue(c47510225.aclimit)
    c:RegisterEffect(e2)
    c:RegisterFlagEffect(47510225,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c47510225.aclimit(e,re,tp)
    local loc=re:GetActivateLocation()
    return loc==LOCATION_ONFIELD and not re:GetHandler():IsImmuneToEffect(e)
end
function c47510225.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c47510225.deop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_BASE_ATTACK)
        e2:SetValue(6000)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e2)    
    end
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetRange(LOCATION_ONFIELD)
    e2:SetTargetRange(0,1)
    e2:SetValue(c47510225.aclimit)
    c:RegisterEffect(e2)
    c:RegisterFlagEffect(47510225,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c47510225.valcon(e,re,r,rp)
    return bit.band(r,REASON_BATTLE)~=0
end