--愚者与愚者
function c22202201.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(c22202201.cost)
	e0:SetOperation(c22202201.activate)
	c:RegisterEffect(e0)
	--Buff
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22202201,2))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetTarget(c22202201.dtg)
	e1:SetOperation(c22202201.dop)
	c:RegisterEffect(e1)
end
function c22202201.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(1-tp)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22202201,0))
	local s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)/0x10000
	nseq=math.log(s,2)
	e:SetLabel(nseq)
end
function c22202201.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local nseq=e:GetLabel()
	if c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(22202201,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCategory(CATEGORY_TOGRAVE)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCondition(c22202201.con)
		e1:SetTarget(c22202201.tg)
		e1:SetOperation(c22202201.op)
		e1:SetLabel(nseq)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c22202201.filter(c,nseq)
	return c:GetSequence()==nseq
end
function c22202201.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22202201.filter,1,nil,e:GetLabel())
end
function c22202201.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(c22202201.filter,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c22202201.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		local g=eg:Filter(c22202201.filter,nil,e:GetLabel()):Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsAbleToGrave,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c22202201.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
end
function c22202201.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	if Duel.Destroy(g,REASON_EFFECT)==0 then return end
	local seq=bit.replace(0,0x1,g:GetFirst():GetPreviousSequence())
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetLabel(seq)
	e1:SetOperation(c22202201.disop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c22202201.disop(e,tp)
	return e:GetLabel()
end