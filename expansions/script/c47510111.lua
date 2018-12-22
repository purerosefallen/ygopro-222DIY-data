--灾祸降诞 异化迪亚波罗
function c47510111.initial_effect(c)
    c:SetSPSummonOnce(47510111)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcCodeFun(c,c47510111.fusfilter1,aux.FilterBoolFunction(Card.IsFusionSetCard,0x5da),1,true,true)
    aux.EnablePendulumAttribute(c,false)
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(SUMMON_TYPE_FUSION)
    e0:SetCondition(c47510111.sprcon)
    e0:SetOperation(c47510111.sprop)
    c:RegisterEffect(e0)
    --The Jaus Codex
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_REVERSE_RECOVER)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(0,1)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --Jaus Pulse
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_NO_BATTLE_DAMAGE)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(0,LOCATION_MZONE)
    e6:SetTarget(c47510111.indestg)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_ATTACK_ALL)
    e7:SetValue(1)
    c:RegisterEffect(e7)
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e8:SetCode(EVENT_BATTLED)
    e8:SetCondition(c47510111.atkcon)
    e8:SetOperation(c47510111.atkop)
    c:RegisterEffect(e8)
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e9:SetCode(EVENT_BATTLE_START)
    e9:SetTarget(c47510111.damtg)
    e9:SetOperation(c47510111.damop)
    c:RegisterEffect(e9)
    --pendulum
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e10:SetCode(EVENT_DESTROYED)
    e10:SetProperty(EFFECT_FLAG_DELAY)
    e10:SetCondition(c47510111.pencon)
    e10:SetTarget(c47510111.pentg)
    e10:SetOperation(c47510111.penop)
    c:RegisterEffect(e10)  
end
function c47510111.fusfilter1(c)
    return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_MONSTER)
end
function c47510111.cfilter(c)
    return (c:IsSetCard(0x5da) or c:IsFusionAttribute(ATTRIBUTE_DARK))
        and c:IsCanBeFusionMaterial() and c:IsReleasable() and c:GetOriginalType()==TYPE_MONSTER
end
function c47510111.spfilter1(c,tp,g)
    return g:IsExists(c47510111.spfilter2,1,c,tp,c)
end
function c47510111.spfilter2(c,tp,mc)
    return (c:IsSetCard(0x5da) and mc:IsFusionAttribute(ATTRIBUTE_DARK)
        or c:IsFusionAttribute(ATTRIBUTE_DARK) and mc:IsSetCard(0x5da))
        and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c47510111.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(c47510111.cfilter,tp,LOCATION_ONFIELD,0,nil)
    return g:IsExists(c47510111.spfilter1,1,nil,tp,g)
end
function c47510111.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(c47510111.cfilter,tp,LOCATION_ONFIELD,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=g:FilterSelect(tp,c47510111.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=g:FilterSelect(tp,c47510111.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    local cg=g1:Filter(Card.IsFacedown,nil)
    if cg:GetCount()>0 then
        Duel.ConfirmCards(1-tp,cg)
    end
    Duel.Release(g1,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end
function c47510111.indestg(e,c)
    return c==e:GetHandler():GetBattleTarget()
end
function c47510111.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle()
end
function c47510111.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-810)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        bc:RegisterEffect(e1)
    end
end
function c47510111.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if tc==c then tc=Duel.GetAttackTarget() end
    if chk==0 then return tc and tc:IsFaceup() and tc:GetAttack()~=tc:GetBaseAttack() end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tc:GetAttack())
end
function c47510111.damop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if tc==c then tc=Duel.GetAttackTarget() end
    if tc:IsRelateToBattle() and tc:GetAttack()~=tc:GetBaseAttack() then
        local atk=tc:GetAttack()
        if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
            Duel.Damage(1-tp,atk,REASON_EFFECT)
        end
    end
end
function c47510111.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47510111.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47510111.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end