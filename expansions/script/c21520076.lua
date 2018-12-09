--玲珑术-圣
function c21520076.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520076,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c21520076.actcon)
	e1:SetCost(c21520076.cost)
	e1:SetTarget(c21520076.target)
	e1:SetOperation(c21520076.activate)
	c:RegisterEffect(e1)
end
function c21520076.actcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_TRAP)
end
function c21520076.filter(c)
	return c:IsReleasable() and c:IsRace(RACE_SPELLCASTER)-- and Duel.IsExistingMatchingCard(c21520076.llfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c21520076.llfilter(c)
	return c:IsSetCard(0x495) and c:IsReleasable() and c:IsRace(RACE_SPELLCASTER)
end
function c21520076.cost(e,tp,eg,ep,ev,re,r,rp,chk)
--[[	if chk==0 then return Duel.IsExistingMatchingCard(c21520076.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c21520076.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:FilterSelect(tp,c21520076.llfilter,1,1,nil)
	g:Sub(sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g2=g:Select(tp,1,1,nil)
	sg:Merge(g2)
	sg:KeepAlive()
	Duel.Release(sg,REASON_COST)
	e:SetLabelObject(sg)--]]
	if chk==0 then return Duel.IsExistingMatchingCard(c21520076.filter,tp,LOCATION_MZONE,0,2,nil) and Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c21520076.filter,tp,LOCATION_MZONE,0,2,2,nil)
	g:KeepAlive()
	Duel.Release(g,REASON_COST)
	e:SetLabelObject(g)
end
function c21520076.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c21520076.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=e:GetLabelObject()
	local tf=false
	local tc=rg:GetFirst()
	local lv1=tc:GetLevel()
	if tc:IsSetCard(0x495) then tf=true 
	else tf=false end
	local tc2=rg:GetNext()
	local lv2=tc2:GetLevel()
	if tc:IsSetCard(0x495) then tf=true 
	else tf=false end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
--[[	if tf and lv1+lv2==6 then
		c:CancelToGrave()
		if Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,c)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end--]]
	if tf then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if lv1+lv2==6 then
		c:CancelToGrave()
		if Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,c)
		end
	end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
		Duel.BreakEffect()
		Duel.DiscardDeck(tp,1,REASON_EFFECT)
	end
end
