--狂战士 姬塔
function c47501002.initial_effect(c)
    --material
    c:EnableReviveLimit() 
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),8,2)
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47501002.psplimit)
    c:RegisterEffect(e1)    
    --Rise IV
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetValue(1500)
    c:RegisterEffect(e2) 
    --Armor Break II
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
    e3:SetDescription(aux.Stringid(47501002,0))
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(c47501002.target)
    e3:SetOperation(c47501002.operation)
    c:RegisterEffect(e3)   
    --repeat attack
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47501002,1))
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_BATTLE_START)
    e4:SetCondition(c47501002.thcon)
    e4:SetCost(c47501002.thcost)
    e4:SetTarget(c47501002.thtg)
    e4:SetOperation(c47501002.thop)
    c:RegisterEffect(e4)  
    --actlimit
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetCode(EFFECT_CANNOT_ACTIVATE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(0,1)
    e5:SetValue(c47501002.aclimit)
    e5:SetCondition(c47501002.actcon)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_IMMUNE_EFFECT)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(c47501002.inmcon)
    e6:SetValue(c47501002.efilter)
    c:RegisterEffect(e6)
end
c47501002.pendulum_level=8
c47501002.card_code_list={47500000}
function c47501002.mfilter(c,xyzc)
    return c:IsLevel(8) and c:IsRace(RACE_WARRIOR)
end
function c47501002.pefilter(c)
    return c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)
end
function c47501002.psplimit(e,c,tp,sumtp,sumpos)
    return not c47501002.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47501002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
        and not e:GetHandler():IsDirectAttacked() end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1)
end
function c47501002.filter(c)
    return c:IsFaceup()
end
function c47501002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c47501002.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47501002.filter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c47501002.filter,tp,0,LOCATION_MZONE,1,1,nil)
    local atk=g:GetFirst():GetTextAttack()
    if atk<0 then atk=0 end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c47501002.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local dg=Group.CreateGroup()
    if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
        local c=e:GetHandler()
        local atk=tc:GetTextAttack()
        if atk<0 then atk=0 end
        if Duel.Damage(1-tp,atk,REASON_EFFECT) then
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_UPDATE_DEFENSE)
            e3:SetValue(-2500)
            e3:SetReset(RESET_EVENT+RESETS_STANDARD)
            tc:RegisterEffect(e3)
        if predef~=0 and tc:IsDefense(0) or tc:IsType(TYPE_LINK) then dg:AddCard(tc) end  
        end
    end
    Duel.Remove(dg,POS_FACEUP,REASON_RULE)
end
function c47501002.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,47500000)
end
function c47501002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c47501002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=c:GetBattleTarget()
    if chk==0 then return tc and tc:IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c47501002.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttacker()
    if c==tc then tc=Duel.GetAttackTarget() end
    if tc and tc:IsRelateToBattle() then
        Duel.Remove(tc,POS_FACEDOWN,REASON_RULE)
    end
    if c:IsRelateToEffect(e) and c:IsChainAttackable() then
        Duel.ChainAttack()
    end
end
function c47501002.inmcon(e)
    return e:GetHandler():GetOverlayCount()==0
end
function c47501002.efilter(e,re)
    return re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_TRAP)
end
function c47501002.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c47501002.actcon(e)
    return (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()) and e:GetHandler():GetOverlayCount()==0
end