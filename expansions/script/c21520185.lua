--艺形魔-纸熊猫
function c21520185.initial_effect(c)
	--destroy and draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetDescription(aux.Stringid(21520185,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21520185)
	e1:SetCondition(c21520185.tgcon)
	e1:SetCost(c21520185.tgcost)
	e1:SetTarget(c21520185.tgtg)
	e1:SetOperation(c21520185.tgop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520185,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21520185)
	e2:SetTarget(c21520185.thtg)
	e2:SetOperation(c21520185.thop)
	c:RegisterEffect(e2)
	local e2_2=e2:Clone()
	e2_2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2_2)
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(21520185,2))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c21520185.drcon)
	e3:SetTarget(c21520185.drtg)
	e3:SetOperation(c21520185.drop)
	c:RegisterEffect(e3)
end
function c21520185.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()&(TYPE_SPELL+TYPE_CONTINUOUS)==TYPE_SPELL+TYPE_CONTINUOUS
end
function c21520185.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c21520185.thfilter(c)
	return c:IsSetCard(0x490) and c:IsAbleToHand()
end
function c21520185.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if Duel.Draw(p,d,REASON_EFFECT)==0 then return end
		local dc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,dc)
		if dc:IsSetCard(0x490) then
			Duel.Draw(p,1,REASON_EFFECT)
		end
		Duel.ShuffleHand(tp)
	end
end
function c21520185.fieldfilter(c)
	return c:IsCode(21520181) and c:IsFaceup()
end
function c21520185.tgcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c21520185.fieldfilter,tp,LOCATION_ONFIELD,0,1,nil) then 
		return Duel.GetTurnPlayer()==tp or Duel.GetTurnPlayer()==1-tp
	else
		return Duel.GetTurnPlayer()==tp
	end
end
function c21520185.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_DISCARD+REASON_COST) 
end
function c21520185.pfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT) and not c:IsPublic()
end
function c21520185.desfilter(c)
	return c:IsSetCard(0x490) and c:IsFaceup()
end
function c21520185.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520185.desfilter,tp,LOCATION_ONFIELD,0,1,nil) 
		and Duel.IsExistingMatchingCard(c21520185.pfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp) end
	local pgc=Duel.GetMatchingGroupCount(c21520185.pfilter,tp,LOCATION_HAND,0,e:GetHandler())
	local dgc=Duel.GetMatchingGroupCount(c21520185.desfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,math.min(pgc,dgc),0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,math.min(pgc,dgc),0,LOCATION_DECK)
end
function c21520185.tgop(e,tp,eg,ep,ev,re,r,rp)
	local pg=Duel.GetMatchingGroup(c21520185.pfilter,tp,LOCATION_HAND,0,nil)
	local dg=Duel.GetMatchingGroup(c21520185.desfilter,tp,LOCATION_ONFIELD,0,nil)
	local ct=math.min(pg:GetCount(),dg:GetCount())
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local pg2=pg:Select(tp,1,ct,nil)
	Duel.ConfirmCards(1-tp,pg2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg2=dg:Select(tp,pg2:GetCount(),pg2:GetCount(),nil)
	if Duel.Destroy(dg2,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		local og=Duel.GetOperatedGroup()
		Duel.Draw(tp,og:GetCount(),REASON_EFFECT)
	end
	Duel.ShuffleHand(tp)
end
function c21520185.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
end
function c21520185.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	local g=Duel.GetDecktopGroup(tp,3)
	Duel.ConfirmDecktop(tp,3)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=g:Select(1-tp,1,1,nil)
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
end
--[[
function c21520185.reccon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep~=tp and tc:IsControler(tp) and tc:IsSetCard(0x490)
end
function c21520185.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
end--]]
