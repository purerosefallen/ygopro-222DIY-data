--炼金工作室-天然的炼金术师
function c4212302.initial_effect(c)
	c:SetUniqueOnField(1,0,4212302)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetOperation(c4212302.activate)
	c:RegisterEffect(e2)
	--copy trap
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4212302,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0x3c0)
	e3:SetCountLimit(1,4212302)
	e3:SetCondition(c4212302.condition)
	e3:SetTarget(c4212302.target1)
	e3:SetOperation(c4212302.operation)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4212302,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,4212302)
	e4:SetTarget(c4212302.target2)
	e4:SetOperation(c4212302.operation)
	c:RegisterEffect(e4)
end
function c4212302.mfilter(c) 
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c4212302.tffilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x2a5) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c4212302.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerCanDiscardDeck(tp,2) 
		and Duel.IsExistingMatchingCard(c4212301.tffilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) then
		if Duel.SelectEffectYesNo(tp,e:GetHandler(),95) then
			if Duel.DiscardDeck(tp,2,REASON_EFFECT)~=0 then
				if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				local tc=Duel.SelectMatchingCard(tp,c4212302.tffilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
				if tc then
					Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				end
			end	
		end
	end
end
function c4212302.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.CheckEvent(EVENT_CHAINING)
end
function c4212302.filter1(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x2a5) and c:CheckActivateEffect(false,true,false)~=nil
end
function c4212302.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then
        local te=e:GetLabelObject()
        local tg=te:GetTarget()
        return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
    end	
	if chk==0 then return Duel.IsExistingTarget(c4212302.filter1,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
	local g=Duel.SelectTarget(tp,c4212302.filter1,tp,LOCATION_SZONE,0,1,1,e:GetHandler())
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function c4212302.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c4212302.filter2(c,e,tp,eg,ep,ev,re,r,rp)
	if c:IsType(TYPE_SPELL) and c:IsSetCard(0x2a5) then
		if c:CheckActivateEffect(false,true,false)~=nil then return true end
		local te=c:GetActivateEffect()
		if te:GetCode()~=EVENT_CHAINING then return false end
		local con=te:GetCondition()
		if con and not con(e,tp,eg,ep,ev,re,r,rp) then return false end
		local tg=te:GetTarget()
		if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
		return true
	else return false end
end
function c4212302.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c4212302.filter2,tp,LOCATION_SZONE,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	local g=Duel.SelectMatchingCard(tp,c4212302.filter2,tp,LOCATION_SZONE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	local te,ceg,cep,cev,cre,cr,crp
	local fchain=c4212302.filter1(tc)
	if fchain then
		te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	else
		te=tc:GetActivateEffect()
	end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		if fchain then
			tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		else
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end