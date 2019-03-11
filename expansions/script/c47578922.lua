--天司长的化身 路西欧
function c47578922.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
        --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47578922.psplimit)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47578922)
    e2:SetTarget(c47578922.thtg)
    e2:SetOperation(c47578922.thop)
    c:RegisterEffect(e2)
    --serch
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,47578923)
    e3:SetCondition(c47578922.thcon)
    e3:SetTarget(c47578922.thtg2)
    e3:SetOperation(c47578922.thop2)
    c:RegisterEffect(e3)
    --boost
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetValue(500)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e6)
    --indes
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e7:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
    e7:SetRange(LOCATION_MZONE)
    e7:SetTargetRange(LOCATION_ONFIELD,0)
    e7:SetValue(c47578922.indct)
    c:RegisterEffect(e7)
    --damage
    local e8=Effect.CreateEffect(c)
    e8:SetCategory(CATEGORY_DAMAGE)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e8:SetCode(EVENT_BATTLED)
    e8:SetCountLimit(1)
    e8:SetCondition(c47578922.damcon)
    e8:SetTarget(c47578922.damtg)
    e8:SetOperation(c47578922.damop)
    c:RegisterEffect(e8)
end
function c47578922.psplimit(e,c,tp,sumtp,sumpos)
    return not c:IsRace(RACE_FAIRY) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47578922.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_FAIRY) and c:IsAbleToHand()
end
function c47578922.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_EXTRA) and c47578922.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47578922.filter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c47578922.filter,tp,LOCATION_EXTRA,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c47578922.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    local c=e:GetHandler()
    if sg:GetCount()>0 then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.Destroy(c,REASON_EFFECT)
    end
end
function c47578922.thcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c47578922.thfilter(c)
    return c:IsSetCard(0x5de) and c:IsLevelAbove(7) and c:IsAbleToHand()
end
function c47578922.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47578922.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47578922.thop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47578922.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47578922.indct(e,re,r,rp)
    if bit.band(r,REASON_BATTLE)~=0 then
        return 1
    else return 0 end
end
function c47578922.damcon(e)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c47578922.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local c=e:GetHandler()
    local atk=c:GetAttack()/2
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(atk)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function c47578922.damop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end