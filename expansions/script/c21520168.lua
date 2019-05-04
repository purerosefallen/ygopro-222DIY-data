--等形魔-瑞克坦
function c21520168.initial_effect(c)
	--cost
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e00:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e00:SetCode(EVENT_PHASE+PHASE_END)
	e00:SetCountLimit(1)
	e00:SetRange(LOCATION_MZONE)
	e00:SetCondition(c21520168.ccon)
	e00:SetOperation(c21520168.ccost)
	c:RegisterEffect(e00)
	--change code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e1:SetValue(21520162)
	c:RegisterEffect(e1)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCost(c21520168.cost)
	e3:SetTarget(c21520168.target)
	e3:SetOperation(c21520168.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c21520168.cfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsPublic()
end
function c21520168.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c21520168.ccost(e,tp)
	if tp~=Duel.GetTurnPlayer() then return end
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g1=Duel.GetMatchingGroup(c21520168.cfilter1,tp,LOCATION_HAND,0,nil)
	local opselect=2
	if g1:GetCount()>0 then
		opselect=Duel.SelectOption(tp,aux.Stringid(21520168,0),aux.Stringid(21520168,1),aux.Stringid(21520168,2))
	else 
		opselect=Duel.SelectOption(tp,aux.Stringid(21520168,1),aux.Stringid(21520168,2))
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
function c21520168.cost(e,tp,eg,ep,ev,re,r,rp,chk)
--[[	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c21520168.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)--]]
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(c21520168.afilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c21520168.afilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c21520168.afilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT) and not c:IsPublic()
end
function c21520168.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x490)
end
function c21520168.tohandfilter(c)
	return c:IsSetCard(0x490) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c21520168.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c21520168.tohandfilter(chkc)) end
	if chk==0 then 
		return Duel.IsExistingTarget(c21520168.tohandfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) 
			or Duel.GetMatchingGroupCount(Duel.IsPlayerCanDraw,tp,LOCATION_DECK,0,nil,tp)>=1 end
	local op=0
	local g1=Duel.IsPlayerCanDraw(tp)
	local g2=Duel.GetMatchingGroupCount(c21520168.tohandfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if g1 and g2>=2 then
		op=Duel.SelectOption(tp,aux.Stringid(21520168,3),aux.Stringid(21520168,4))+1
	elseif g1 then
		op=1
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520168,3))
	elseif g2>=2 then
		op=2
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(21520168,4))
	end
	if op==1 then
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,1)
	elseif op==2 then
		local g=Duel.SelectTarget(tp,c21520168.tohandfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
	e:SetLabel(op)
end
function c21520168.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-p,tc)
		if tc:IsSetCard(0x490) then
			Duel.Draw(p,1,REASON_EFFECT)
		end
	elseif e:GetLabel()==2 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local sg=g:Filter(Card.IsRelateToEffect,nil,e)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
