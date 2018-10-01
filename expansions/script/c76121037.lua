--赫里奥波里斯之飞刀龙
function c76121037.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c76121037.spcon)
	e1:SetOperation(c76121037.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76121037,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,76121037)
	e2:SetTarget(c76121037.thtg)
	e2:SetOperation(c76121037.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--become material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCondition(c76121037.mtcon)
	e4:SetOperation(c76121037.mtop)
	c:RegisterEffect(e4)
end
function c76121037.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,c)
end
function c76121037.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(76121037,4))
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoHand(g,1-tp,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xea4))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c76121037.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c76121037.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 and Duel.Draw(1-tp,1,REASON_EFFECT)~=0 then
		if e:GetLabel()==1 and Duel.IsPlayerCanDraw(tp,1)
		and Duel.SelectYesNo(tp,aux.Stringid(76121037,1)) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c76121037.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL
end
function c76121037.mtop(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	while rc do
		if rc:GetFlagEffect(76121037)==0 then
			--untargetable
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(76121037,2))
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EVENT_ATTACK_ANNOUNCE)
			e1:SetOperation(c76121037.desop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e1,true)
			rc:RegisterFlagEffect(76121037,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		rc=eg:GetNext()
	end
end
function c76121037.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(76121037,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end