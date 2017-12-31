--S.T. 爆音歌姬
function c22270002.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22270002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,222700021)
	e1:SetCost(c22270002.cost)
	e1:SetTarget(c22270002.target)
	e1:SetOperation(c22270002.operation)
	c:RegisterEffect(e1)
	--ToHand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22270002,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,222700022)
	e2:SetCondition(c22270002.con)
	e2:SetTarget(c22270002.tg)
	e2:SetOperation(c22270002.op)
	c:RegisterEffect(e2)
end
c22270002.named_with_ShouMetsu_ToShi=1
function c22270002.IsShouMetsuToShi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ShouMetsu_ToShi
end
function c22270002.filter(c)
	return c:IsType(TYPE_LINK) and c:IsRace(RACE_MACHINE)
end
function c22270002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD):Filter(c22270002.filter,nil)
	local lc=g:GetFirst()
	local lg=Group.CreateGroup()
	while lc do 
		lg:Merge(lc:GetLinkedGroup())
		lc=g:GetNext()
	end
	local lg1=lg:Filter(Card.IsControler,nil,tp):Filter(Card.IsAbleToHandAsCost,nil)
	local lg2=lg:Filter(Card.IsControler,nil,1-tp):Filter(Card.IsAbleToHandAsCost,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if ft<1 then
			return lg1:GetCount()>0
		else
			return lg:GetCount()>0
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	if ft<1 then
		local cg=lg1:Select(tp,1,1,nil)
		Duel.SendtoHand(cg,nil,REASON_COST)
	else
		local cg=lg:Select(tp,1,1,nil)
		Duel.SendtoHand(cg,nil,REASON_COST)
	end
end
function c22270002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22270002.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22270002.con(e,tp,eg,ep,ev,re,r,rp)
	local i=0
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD):Filter(c22270002.filter,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetLinkedGroup():IsContains(e:GetHandler()) then return true end
		tc=g:GetNext()
	end
end
function c22270002.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c22270002.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end