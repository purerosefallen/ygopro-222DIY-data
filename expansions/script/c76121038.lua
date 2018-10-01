--赫里奥波里斯之圣盾龙
function c76121038.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c76121038.spcon)
	e1:SetOperation(c76121038.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76121038,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,76121038)
	e2:SetTarget(c76121038.thtg)
	e2:SetOperation(c76121038.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--become material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c76121038.mtcon)
	e4:SetOperation(c76121038.mtop)
	c:RegisterEffect(e4)
end
function c76121038.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,c)
end
function c76121038.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(76121038,3))
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoHand(g,1-tp,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c76121038.chainop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c76121038.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0xea4) then
		Duel.SetChainLimit(c76121038.chainlm)
	end
end
function c76121038.chainlm(e,rp,tp)
	return tp==rp
end
function c76121038.thfilter(c)
	return c:IsSetCard(0xea4) and not c:IsCode(76121038) and c:IsAbleToHand()
end
function c76121038.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c76121038.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
		e:SetLabel(1)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetLabel(0)
	end
end
function c76121038.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c76121038.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if e:GetLabel()==1 and Duel.IsPlayerCanDraw(tp,1)
		and Duel.SelectYesNo(tp,aux.Stringid(76121038,1)) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c76121038.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL
end
function c76121038.mtop(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	while rc do
		if rc:GetFlagEffect(76121038)==0 then
			--untargetable
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(76121038,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1)
			rc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			rc:RegisterEffect(e2,true)
			rc:RegisterFlagEffect(76121038,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		rc=eg:GetNext()
	end
end