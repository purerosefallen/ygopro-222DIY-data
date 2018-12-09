--武勇的星晶兽 哪吒
function c47510028.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)  
    --damage
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLE_START)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47510028)
    e2:SetCondition(c47510028.pcon)
    e2:SetTarget(c47510028.ptg)
    e2:SetOperation(c47510028.pop)
    c:RegisterEffect(e2)
    --spsum
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,47510029)
    e3:SetOperation(c47510028.atkop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --sunmoneffect
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_ATKCHANGE)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_EXTRA)
    e5:SetCountLimit(1,47510000)
    e5:SetCost(c47510028.cost)
    e5:SetTarget(c47510028.datg)
    e5:SetOperation(c47510028.daop)
    c:RegisterEffect(e5)
    c47510028.ss_effect=e5
    --doubleattack
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EVENT_BATTLED)
    e7:SetCondition(c47510028.cacon)
    e7:SetOperation(c47510028.caop)
    c:RegisterEffect(e7)
    --recover
    local e8=Effect.CreateEffect(c)
    e8:SetCategory(CATEGORY_DRAW)
    e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCondition(c47510028.drcon)
    e8:SetTarget(c47510028.drtg)
    e8:SetOperation(c47510028.drop)
    c:RegisterEffect(e8)
end
function c47510028.pcon(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttacker()
    local a=Duel.GetAttacker()
    local d=a:GetBattleTarget()
    if a:IsControler(1-tp) then a,d=d,a end
    return a and a:IsFaceup() and a:IsRelateToBattle() and d and d:IsFaceup() and d:IsRelateToBattle() and a:GetControler()~=d:GetControler() and (at:IsAttribute(ATTRIBUTE_WIND) or at:IsSetCard(0x5da))
end
function c47510028.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47510028.pop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local a=Duel.GetAttacker()
    local d=a:GetBattleTarget()
    if a:IsControler(1-tp) then a,d=d,a end
    if c:IsRelateToEffect(e) then
       if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(2700)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
        a:RegisterEffect(e1)
    end
end
function c47510028.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1000)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end
function c47510028.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c47510028.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetEffectCount(EFFECT_DIRECT_ATTACK)==0
end
function c47510028.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c47510028.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47510028.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c47510028.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c47510028.daop(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DIRECT_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
    end
end
function c47510028.cacon(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    if not d then return false end
    if a:IsStatus(STATUS_OPPO_BATTLE) and d:IsControler(tp) then a,d=d,a end
    if a:IsAttribute(ATTRIBUTE_FIRE)
        and not a:IsStatus(STATUS_BATTLE_DESTROYED) and d:IsStatus(STATUS_BATTLE_DESTROYED) then
        e:SetLabelObject(a)
        return true
    else return false end
end
function c47510028.caop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:IsFaceup() and tc:IsControler(tp) and tc:IsRelateToBattle() then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetValue(-500)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
        tc:RegisterEffect(e1)
        if tc:IsChainAttackable() then
            Duel.ChainAttack()
        end
    end
end
function c47510028.drcon(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    if not d then return false end
    if a:IsStatus(STATUS_OPPO_BATTLE) and d:IsControler(tp) then a,d=d,a end
    if a:IsAttribute(ATTRIBUTE_WIND)
        and not a:IsStatus(STATUS_BATTLE_DESTROYED) and d:IsStatus(STATUS_BATTLE_DESTROYED) then
        e:SetLabelObject(a)
        return true
    else return false end
end
function c47510028.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c47510028.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end