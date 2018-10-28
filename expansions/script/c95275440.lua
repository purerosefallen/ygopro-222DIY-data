--亚里亚—伪装突袭
function c95275440.initial_effect(c)
  --Damage
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c95275440.damtg)
    e1:SetOperation(c95275440.damop)
    c:RegisterEffect(e1)
  --Remove
      local e2=Effect.CreateEffect(c)
      e2:SetDescription(aux.Stringid(95275440,1))      
      e2:SetCategory(CATEGORY_REMOVE)
      e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
      e2:SetType(EFFECT_TYPE_QUICK_O)
      e2:SetCode(EVENT_FREE_CHAIN)
      e2:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)
      e2:SetRange(LOCATION_GRAVE)
      e2:SetCost(aux.bfgcost)
      e2:SetCondition(c95275440.condition)
      e2:SetTarget(c95275440.target)
      e2:SetOperation(c95275440.activate)
      c:RegisterEffect(e2)
end
function c95275440.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c95275440.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(120)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,120)
end
function c95275440.damop(e,tp,eg,ep,ev,re,r,rp)
local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
Duel.Damage(p,d,REASON_EFFECT)
end
function c95275440.condition(e,tp,eg,ep,ev,re,r,rp)
    local ph=Duel.GetCurrentPhase()
    return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or ph==PHASE_BATTLE)
end
function c95275440.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c95275440.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Remove(tc,REASON_EFFECT,nil,POS_FACEDOWN)
    end
end
function c95275440.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
        Duel.SetChainLimit(aux.FALSE)
    end
end

