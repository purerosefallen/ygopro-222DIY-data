--义贼 姬塔
function c47501009.initial_effect(c)
    --material
    c:EnableReviveLimit() 
    aux.AddXyzProcedureLevelFree(c,c47501009.mfilter,c47501009.xyzcheck,2,2)
    --pendulum summon
    aux.EnablePendulumAttribute(c,false) 
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47501009.psplimit)
    c:RegisterEffect(e1)
    --drop
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47501009,0))
    e3:SetCategory(CATEGORY_COUNTER)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCountLimit(1)
    e3:SetOperation(c47501009.ctop)
    c:RegisterEffect(e3)   
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47501009,1))
    e2:SetCategory(CATEGORY_COUNTER)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCost(c47501009.dropcost)
    e2:SetCondition(c47501009.dropcon)
    e2:SetTarget(c47501009.drtg)
    e2:SetOperation(c47501009.dropop)
    c:RegisterEffect(e2)  
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47501009,2))
    e4:SetCategory(CATEGORY_ATKCHANGE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_BATTLE_START)
    e4:SetTarget(c47501009.bktg)
    e4:SetOperation(c47501009.bkop)
    c:RegisterEffect(e4)   
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47501009,3))
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetCountLimit(1)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCost(c47501009.excost)
    e5:SetTarget(c47501009.extg)
    e5:SetOperation(c47501009.exop)
    c:RegisterEffect(e5) 
end
c47501009.pendulum_level=8
c47501009.card_code_list={47500000}
function c47501009.mfilter(c)
    return c:IsLevel(8)
end
function c47501009.mzfilter(c,xyzc)
    return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c47501009.pefilter(c)
    return c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)
end
function c47501009.psplimit(e,c,tp,sumtp,sumpos)
    return not c47501009.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47501009.xyzcheck(g)
    return g:IsExists(c47501009.mzfilter,1,nil)
end
function c47501009.dropcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,1,1,REASON_COST) end
    if Duel.RemoveOverlayCard(tp,1,1,1,1,REASON_COST) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local g=Duel.SelectMatchingCard(tp,c47501009.rfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
        Duel.SendtoGrave(g,REASON_COST)
    end
end
function c47501009.dropcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,47500000)
end
function c47501009.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c47501009.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(tp,1,REASON_EFFECT)
end
function c47501009.rfilter(c)
    return c:GetCounter(0x105d)>3 and c:IsAbleToGraveAsCost()
end
function c47501009.ctop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do 
        tc:AddCounter(0x105d,3)
        tc=g:GetNext()
    end
end
function c47501009.bktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=Duel.GetAttacker()
    if tc==e:GetHandler() then tc=Duel.GetAttackTarget() end
    if chk==0 then return tc and tc:IsRelateToBattle() and tc:IsDisabled() end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c47501009.bkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetAttacker()
    if tc==e:GetHandler() then tc=Duel.GetAttackTarget() end
    if tc:IsRelateToBattle() and tc:IsDisabled() then
        local atk=c:GetAttack()
        local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
        e1:SetValue(atk*3)
        c:RegisterEffect(e1)
    end
end
function c47501009.excost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47501009.extg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,1,nil) end
end
function c47501009.exop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
    Duel.ConfirmCards(tp,g)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local sg=g:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil)
    if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then
        Duel.SendtoHand(sg,tp,REASON_EFFECT)
    end
end