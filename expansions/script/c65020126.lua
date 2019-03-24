--响色混涂·锈影
function c65020126.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,65020117,65020119,true,true)
	--effect!
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65020126)
	e1:SetCost(c65020126.cost)
	e1:SetTarget(c65020126.tg)
	e1:SetOperation(c65020126.op)
	c:RegisterEffect(e1)
	--change seq
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c65020126.seqcon)
	e2:SetTarget(c65020126.seqtg)
	e2:SetOperation(c65020126.seqop)
	c:RegisterEffect(e2)
end
function c65020126.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c65020126.efffil(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c65020126.firefil(c,e,tp)
	return c:IsCode(65020117) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c65020126.eartfil(c)
	return c:IsCode(65020119) and c:IsAbleToGrave()
end
function c65020126.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c65020126.efffil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65020126.efffil,tp,0,LOCATION_ONFIELD,1,nil) and (Duel.IsExistingMatchingCard(c65020126.firefil,tp,LOCATION_HAND,0,1,nil,e,tp) or Duel.IsExistingMatchingCard(c65020126.eartfil,tp,LOCATION_REMOVED,0,1,nil)) end
	local g=Duel.SelectTarget(tp,c65020126.efffil,tp,0,LOCATION_ONFIELD,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c65020126.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if not c:IsStatus(STATUS_ACT_FROM_HAND) and c:IsLocation(LOCATION_SZONE) then
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_DISABLE)
			e4:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
			e4:SetTarget(c65020126.distg)
			e4:SetReset(RESET_PHASE+PHASE_END)
			e4:SetLabel(c:GetSequence())
			Duel.RegisterEffect(e4,tp)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e5:SetCode(EVENT_CHAIN_SOLVING)
			e5:SetOperation(c65020126.disop)
			e5:SetReset(RESET_PHASE+PHASE_END)
			e5:SetLabel(c:GetSequence())
			Duel.RegisterEffect(e5,tp)
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_FIELD)
			e6:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e6:SetTarget(c65020126.distg)
			e6:SetReset(RESET_PHASE+PHASE_END)
			e6:SetLabel(c:GetSequence())
			Duel.RegisterEffect(e6,tp)
		end
			Duel.BreakEffect()
			local b1=Duel.IsExistingMatchingCard(c65020126.firefil,tp,LOCATION_HAND,0,1,nil,e,tp)
			local b2=Duel.IsExistingMatchingCard(c65020126.eartfil,tp,LOCATION_REMOVED,0,1,nil)
			local m=2
			if b1 and b2 then
				m=Duel.SelectOption(tp,aux.Stringid(65020126,0),aux.Stringid(65020126,1))
			elseif b1 then
				m=0
			elseif b2 then
				m=1
			end
			if m==0 then
				local g1=Duel.IsExistingMatchingCard(c65020126.firefil,tp,LOCATION_HAND,0,1,nil,e,tp)
				Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
			elseif m==1 then
				local g2=Duel.SelectMatchingCard(tp,c65020126.eartfil,tp,LOCATION_REMOVED,0,1,1,nil)
				Duel.SendtoGrave(g2,REASON_EFFECT)
			end
	end
end
function c65020126.distg(e,c)
	local seq=e:GetLabel()
	local p=c:GetControler()
	local tp=e:GetHandlerPlayer()
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
		and ((p==tp and c:GetSequence()==seq) or (p==1-tp and c:GetSequence()==4-seq))
end
function c65020126.disop(e,tp,eg,ep,ev,re,r,rp)
	local tseq=e:GetLabel()
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if bit.band(loc,LOCATION_SZONE)~=0 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and ((rp==tp and seq==tseq) or (rp==1-tp and seq==4-tseq)) then
		Duel.NegateEffect(ev)
	end
end
function c65020126.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
function c65020126.seqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c65020126.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
end
function c65020126.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
end

