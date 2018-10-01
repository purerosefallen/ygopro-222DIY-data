--此刻的神色
function c65071092.initial_effect(c)
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65071092.target)
	e1:SetOperation(c65071092.activate)
	c:RegisterEffect(e1)
end
function c65071092.filter(c,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
end
function c65071092.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and ((chkc:IsControler(tp) and c65071092.filter(chkc,tp)) or (chkc:IsControler(1-tp) and c65071092.filter(chkc,1-tp))) end
	if chk==0 then return Duel.IsExistingTarget(c65071092.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(65071092,0))
	Duel.SelectTarget(tp,c65071092.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
end
function c65071092.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or ((tc:IsControler(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)<1) or (tc:IsControler(1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)<1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	if tc:IsControler(tp) then
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(tc,nseq)
	end
	if tc:IsControler(1-tp) then
		local s=Duel.SelectDisableField(1-tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(tc,nseq)
	end
end