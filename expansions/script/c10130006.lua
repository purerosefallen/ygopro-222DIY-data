--幻层驱动器 真空层
function c10130006.initial_effect(c)
	--ATK
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DEFCHANGE)
	e1:SetDescription(aux.Stringid(10130006,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10130006)
	e1:SetTarget(c10130006.atktg)
	e1:SetOperation(c10130006.atkop)
	c:RegisterEffect(e1)	
	--position
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetDescription(aux.Stringid(10130006,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,10130106)
	e2:SetCost(c10130006.poscost)
	e2:SetTarget(c10130006.postg)
	e2:SetOperation(c10130006.posop)
	c:RegisterEffect(e2)
	c10130006.flip_effect=e1
end
function c10130006.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	Duel.ConfirmCards(1-tp,c)
end
function c10130006.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,tp,0)
end
function c10130006.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectMatchingCard(1-tp,Card.IsFacedown,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
	   Duel.HintSelection(g)
	   Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	end
end
function c10130006.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c10130006.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10130006.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c10130006.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10130006.filter,tp,0,LOCATION_MZONE,nil)
	local tc,c=g:GetFirst(),e:GetHandler()
	while tc do
		  local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		  e1:SetValue(0)
		  e1:SetReset(RESET_EVENT+0x1fe0000)
		  tc:RegisterEffect(e1)
		  local e2=e1:Clone()
		  e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
		  tc:RegisterEffect(e2)
		  local e3=e1:Clone()
		  e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		  e3:SetValue(1)
		  tc:RegisterEffect(e3)
		  tc=g:GetNext()
	end
	if g:IsExists(aux.FilterEqualFunction(Card.GetAttack,0),1,nil) and c:IsCanTurnSet() and Duel.SelectYesNo(tp,aux.Stringid(10130006,2)) then
	   Duel.BreakEffect()
	   Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	   local sg=Duel.GetMatchingGroup(c10130006.ssfilter,tp,LOCATION_MZONE,0,nil)
	   Duel.ShuffleSetCard(sg)
	end
end
function c10130006.ssfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end