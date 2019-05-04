--Orica
function c98301040.initial_effect(c)
	--download
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98301040,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,98301040)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c98301040.dlcon)
	e1:SetTarget(c98301040.dltg)
	e1:SetOperation(c98301040.dlop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98301040,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c98301040.thcon)
	e2:SetTarget(c98301040.thtg)
	e2:SetOperation(c98301040.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(c98301040.thcon2)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(aux.chainreg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(98301040,3))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1)
	e5:SetCondition(c98301040.drcon)
	e5:SetTarget(c98301040.drtg)
	e5:SetOperation(c98301040.drop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(98301040)
	c:RegisterEffect(e6)
end

function c98301040.dlcon(e,tp,eg,ep,ev,re,r,rp)
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tc=te:GetHandler()
		if tgp==tp and (tc:IsSetCard(0xad3) or tc:IsSetCard(0xad4)) then
			return true
		end
	end
	return false
end
function c98301040.dltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98301040)==0 end
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		local tc=te:GetHandler()
		if tgp==tp and (tc:IsSetCard(0xad3) or tc:IsSetCard(0xad4)) then
			dg:AddCard(tc)
		end
	end
	Duel.SetTargetCard(dg)
end
function c98301040.dlop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,98301040)~=0 then return false end
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
			local tc=te:GetHandler()
		if tgp==tp and (tc:IsSetCard(0xad3) or tc:IsSetCard(0xad4)) then
			if tc then
				dg:AddCard(tc)
			end
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(98301040,4))
	local dl=dg:Select(tp,1,1,nil)
	local dlc=dl:GetFirst():GetCode()
	Duel.RegisterFlagEffect(tp,98301040,nil,0,1,dlc)
end

function c98301040.thfilter(c,tp)
	local cod=Duel.GetFlagEffectLabel(tp,98301040)
	return c:IsCode(cod) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c98301040.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c98301040.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c98301040.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98301040.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98301040.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,98300000)
end
function c98301040.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,98300000)
end

function c98301040.drfilter(c)
	return c:IsAbleToDeck() and (c:IsSetCard(0xad3) or c:IsSetCard(0xad4))
end
function c98301040.drcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:GetType()==TYPE_SPELL and (rc:IsSetCard(0xad3) or rc:IsSetCard(0xad4)) and rp==tp and Duel.IsExistingMatchingCard(c98301040.drfilter,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():GetFlagEffect(1)>0
end
function c98301040.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		Duel.IsExistingMatchingCard(c98301040.drfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98301040.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c98301040.drfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c98301040.drfilter,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end