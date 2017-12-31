--S.T. 链接解析者
function c22270001.initial_effect(c)
	--Disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22270161,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,222700011)
	e1:SetTarget(c22270001.distg)
	e1:SetOperation(c22270001.disop)
	c:RegisterEffect(e1)
	--ToHand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22270161,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,222700012)
	e2:SetCondition(c22270001.thcon)
	e2:SetTarget(c22270001.thtg)
	e2:SetOperation(c22270001.thop)
	c:RegisterEffect(e2)
end
c22270001.named_with_ShouMetsu_ToShi=1
function c22270001.IsShouMetsuToShi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ShouMetsu_ToShi
end
function c22270001.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,TYPE_LINK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,TYPE_LINK)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,0,0,0,0)
end
function c22270001.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=tc:GetLinkedGroup()
		local dc=g:GetFirst()
		while dc do
			if dc:IsFaceup() then
				Duel.NegateRelatedChain(dc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				dc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				dc:RegisterEffect(e2)
			end
			dc=g:GetNext()
		end
	end
end
function c22270001.cfilter(c,tp)
	return c:IsType(TYPE_LINK) and c:IsSummonType(SUMMON_TYPE_LINK) and c:GetSummonPlayer()==tp
end
function c22270001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22270001.cfilter,1,nil,tp)
end
function c22270001.matfilter(c,tp)
	return c:IsRace(RACE_MACHINE) and c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c:IsAbleToHand()
end
function c22270001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=eg:Filter(c22270001.cfilter,nil,tp)
	local mg=Group.CreateGroup()
	local lc=lg:GetFirst()
	while lc do 
		local sg=lc:GetMaterial():Filter(c22270001.matfilter,nil,tp)
		mg:Merge(sg)
		lc=lg:GetNext()
	end
	if chk==0 then return mg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,1,0,0)
end
function c22270001.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=eg:Filter(c22270001.cfilter,nil,tp)
	local mg=Group.CreateGroup()
	local lc=lg:GetFirst()
	while lc do 
		local sg=lc:GetMaterial():Filter(c22270001.matfilter,nil,tp)
		mg:Merge(sg)
		lc=lg:GetNext()
	end
	if mg:GetCount()>0 then
		local tg=mg:Select(tp,1,1,nil)
		if tg:GetCount()>0 then 
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			if tg:GetFirst():IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,tg) end
		end
	end
end