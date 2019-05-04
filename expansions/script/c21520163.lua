--形魔-彭特贡
function c21520163.initial_effect(c)
	--cost
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e00:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e00:SetCode(EVENT_PHASE+PHASE_END)
	e00:SetCountLimit(1)
	e00:SetRange(LOCATION_MZONE)
	e00:SetCondition(c21520163.ccon)
	e00:SetOperation(c21520163.ccost)
	c:RegisterEffect(e00)
	--Attribute Dark
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520163,3))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCost(c21520163.drcost)
	e3:SetTarget(c21520163.drtg)
	e3:SetOperation(c21520163.drop)
	c:RegisterEffect(e3)
end
function c21520163.cfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsPublic()
end
function c21520163.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c21520163.ccost(e,tp)
	if tp~=Duel.GetTurnPlayer() then return end
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g1=Duel.GetMatchingGroup(c21520163.cfilter1,tp,LOCATION_HAND,0,nil)
	local opselect=2
	if g1:GetCount()>0 then
		opselect=Duel.SelectOption(tp,aux.Stringid(21520163,0),aux.Stringid(21520163,1),aux.Stringid(21520163,2))
	else 
		opselect=Duel.SelectOption(tp,aux.Stringid(21520163,1),aux.Stringid(21520163,2))
		opselect=opselect+1
	end
	if opselect==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=g1:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	elseif opselect==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_ATKCHANGE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(-c:GetAttack())
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCategory(CATEGORY_DEFCHANGE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-c:GetDefense())
		c:RegisterEffect(e2)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
function c21520163.rfilter(c)
	return (c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_LIGHT)) and c:IsAbleToGraveAsCost()
end
function c21520163.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520163.rfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21520163.rfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,POS_FACEUP,REASON_COST)
end
function c21520163.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21520163.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
