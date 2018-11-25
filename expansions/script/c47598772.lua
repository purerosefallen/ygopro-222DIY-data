--圣少女 贞德
function c47598772.initial_effect(c)
      --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(c47598772.synfilter),1)
    c:EnableReviveLimit()  
    aux.EnablePendulumAttribute(c,false) 
    --destroy and damage
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47598772,0))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,47598772)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCondition(c47598772.descon)
    e1:SetTarget(c47598772.destg)
    e1:SetOperation(c47598772.desop)
    c:RegisterEffect(e1) 
    --salvage
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47598772,3))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCondition(c47598772.tfcon)
    e2:SetTarget(c47598772.tftg)
    e2:SetOperation(c47598772.tfop)
    c:RegisterEffect(e2) 
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BATTLE_START)
    e3:SetOperation(c47598772.actop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_BE_BATTLE_TARGET)
    c:RegisterEffect(e4)
    --pendulum
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(47598772,3))
    e8:SetCategory(CATEGORY_TOHAND)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_DESTROYED)
    e8:SetProperty(EFFECT_FLAG_DELAY)
    e8:SetCondition(c47598772.pencon)
    e8:SetTarget(c47598772.pentg)
    e8:SetOperation(c47598772.penop)
    c:RegisterEffect(e8)
end
function c47598772.synfilter(c)
    return c:IsType(TYPE_PENDULUM)
end
function c47598772.descon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttacker():GetControler()~=tp
end
function c47598772.desfilter1(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x5d0)
        and Duel.IsExistingMatchingCard(c47598772.desfilter2,tp,0,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c47598772.desfilter2(c,atk)
    return c:IsFaceup() and c:IsDefenseBelow(atk)
end
function c47598772.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c47598772.desfilter1(chkc,tp) end
    if chk==0 then return Duel.IsExistingTarget(c47598772.desfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local tc=Duel.SelectTarget(tp,c47598772.desfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
    local g=Duel.GetMatchingGroup(c47598772.desfilter2,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*1000)
end
function c47598772.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local g=Duel.GetMatchingGroup(c47598772.desfilter2,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
        if g:GetCount()==0 then return end
        local oc=Duel.Destroy(g,REASON_EFFECT)
        if oc>0 then Duel.Damage(1-tp,oc*500,REASON_EFFECT) end
    end
end
function c47598772.tfcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47598772.ppfilter(c)
    return c:IsCode(47598776)
end
function c47598772.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(c47598772.ppfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c47598772.tfop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c47598772.ppfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 then
       Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
   end
end
function c47598772.actop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttackTarget()
    local dg=Group.CreateGroup()
    if not tc then return end
    if tc:IsControler(tp) then tc=Duel.GetAttacker() end
    local atk=c:GetAttack()
    local def=tc:GetBaseDefense()
    local lp=Duel.GetLP(1-tp)
    if tc:IsType(TYPE_LINK) then
        Duel.SetLP(1-tp,lp-atk)
        dg:AddCard(tc)
    end
    if atk>def and not tc:IsType(TYPE_LINK) and Duel.Damage(1-tp,atk-def,REASON_BATTLE) then
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_UPDATE_DEFENSE)
        e3:SetValue(-atk)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e3)
        if predef~=0 and tc:IsDefense(0) then dg:AddCard(tc) end
    end
    Duel.Remove(dg,POS_FACEUP,REASON_RULE)
end
function c47598772.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47598772.pspfilter(c,e,tp)
    return c:IsAbleToHand() and c:IsType(TYPE_PENDULUM)
end
function c47598772.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(c47598772.pspfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c47598772.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local c=e:GetHandler()
    local g=Duel.SelectMatchingCard(tp,c47598772.pspfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
       Duel.SendtoHand(g,nil,REASON_EFFECT)
       Duel.BreakEffect()
       Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end