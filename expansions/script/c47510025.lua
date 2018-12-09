--双子的星晶兽 弗拉姆=格拉姆
function c47510025.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47510025+EFFECT_COUNT_CODE_DUEL)
    e2:SetTarget(c47510025.tktg)
    e2:SetOperation(c47510025.tkop)
    c:RegisterEffect(e2) 
    --Attribute Dark
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_ADD_ATTRIBUTE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetValue(ATTRIBUTE_WATER)
    c:RegisterEffect(e3)
    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCountLimit(1,47510026)
    e4:SetTarget(c47510025.destg)
    e4:SetOperation(c47510025.desop)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e5)
    --sunmoneffect
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetRange(LOCATION_EXTRA)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetCountLimit(1,47510000)
    e6:SetCondition(c47510025.condition)
    e6:SetCost(c47510025.cost)
    e6:SetOperation(c47510025.disop)
    c:RegisterEffect(e6)
    c47510025.ss_effect=e6
    --recover
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_RECOVER)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCode(EVENT_BATTLE_DAMAGE)
    e7:SetCondition(c47510025.reccon)
    e7:SetTarget(c47510025.rectg)
    e7:SetOperation(c47510025.recop)
    c:RegisterEffect(e7)
    --recover
    local e8=Effect.CreateEffect(c)
    e8:SetCategory(CATEGORY_RECOVER)
    e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCode(EVENT_BATTLE_DAMAGE)
    e8:SetCondition(c47510025.descon2)
    e8:SetTarget(c47510025.destg2)
    e8:SetOperation(c47510025.desop2)
    c:RegisterEffect(e8)
end
function c47510025.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local atk=2000
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,47511001,0,0x5da,atk,atk,1,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_DEFENSE) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c47510025.tkop(e,tp,eg,ep,ev,re,r,rp)
    local atk=2000
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=2
        or not Duel.IsPlayerCanSpecialSummonMonster(tp,47511001,0,0x5da,atk,atk,1,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP_DEFENSE) then return end
    local token=Duel.CreateToken(tp,47511001)
    if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UNRELEASABLE_SUM)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        token:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
        token:RegisterEffect(e2)
    end
    if Duel.SpecialSummonComplete()~=0 and c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510025.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47510025.splimit(e,c)
    return not c:IsSetCard(0x5da) or c:IsType(TYPE_PENDULUM)
end
function c47510025.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c47510025.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
function c47510025.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetLP(tp)<=1000
end
function c47510025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c47510025.disop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CANNOT_TRIGGER)
        e1:SetReset(RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_CANNOT_ATTACK)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e3)
       tc=g:GetNext()
    end
end
function c47510025.reccon(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp then return false end
    local rc=eg:GetFirst()
    return rc:IsControler(tp) and rc:IsAttribute(ATTRIBUTE_WATER)
end
function c47510025.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(ev)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c47510025.recop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end
function c47510025.descon2(e,tp,eg,ep,ev,re,r,rp)
    if ep==tp then return false end
    local rc=eg:GetFirst()
    return rc:IsControler(tp) and rc:IsAttribute(ATTRIBUTE_FIRE)
end
function c47510025.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c47510025.desop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.Destroy(g,REASON_EFFECT)
    end
end