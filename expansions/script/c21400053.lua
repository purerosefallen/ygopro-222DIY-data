--露文律的绘盾
function c21400053.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21400053,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,21400053)
	e1:SetCondition(c21400053.con)
	e1:SetTarget(c21400053.tg)
	e1:SetOperation(c21400053.op)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21400053,1))
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c21400053.target)
	e2:SetOperation(c21400053.activate)
	c:RegisterEffect(e2)

end





function c21400053.con(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_DRAW)
end

function c21400053.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end

function c21400053.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SSet(tp,c)
	e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end





function c21400053.multiattf(c,tp)
	if not c:IsType(TYPE_MONSTER) then return false end
	local minn,maxn=c:GetTributeRequirement()
	if maxn<=0 or not c:IsAbleToHand() then return false end
	--local lcfl=		
	local num=0
	--local nolv=0
	local lolv=c:GetLevel()
	--while num<lolv do
	--	nolv=nolv+3
	--	num=num+1
	--end
	num=(lolv+2)/3
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0xc21)
	--Group.Filter

	g=g:Filter(Card.IsAbleToGrave,nil)
	local attcnt=g:GetClassCount(Card.GetAttribute)
	if Duel.IsExistingMatchingCard(Card.IsSummonType,tp,LOCATION_MZONE,0,1,nil,SUMMON_TYPE_ADVANCE) then --exist advanced moster
		Debug.Message("there is advanced!")
		if attcnt>=num then return true end
	else
		Debug.Message("there NOO advanced!")
		if g:FilterCount(Card.IsAttribute,nil,c:GetAttribute())<=0 then return false end
		Debug.Message("same attribute do exist")
		if attcnt+1>=num then return true end
	end
	return false
end


function c21400053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c21400053.multiattf,tp,LOCATION_DECK,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
end

function c21400053.sf(c,att)
	return c:IsSetCard(0xc21) and c:IsAttribute(att)
end

function c21400053.snf(c,att)
	return c:IsSetCard(0xc21) and (c:GetAttribute()&att)==0
end

function c21400053.activate(e,tp,eg,ep,ev,re,r,rp)

	if not Duel.IsExistingMatchingCard(c21400053.multiattf,tp,LOCATION_DECK,0,1,nil,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21400053.multiattf,tp,LOCATION_DECK,0,1,1,nil,tp)
	local c=g:GetFirst()

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local lalv=c:GetLevel()
	--local lcfl=
	local attg=Group.CreateGroup()
	local attset=0
	if not Duel.IsExistingMatchingCard(Card.IsSummonType,tp,LOCATION_MZONE,0,1,nil,SUMMON_TYPE_ADVANCE) then
		attg=Duel.SelectMatchingCard(tp,c21400053.sf,tp,LOCATION_DECK,0,1,1,nil,c:GetAttribute())
		local attc=attg:GetFirst()
		attset=attset | attc:GetAttribute()
		lalv=lalv-3
	end

	while lalv>0 do
		local attng=Duel.SelectMatchingCard(tp,c21400053.snf,tp,LOCATION_DECK,0,1,1,nil,attset)
		Group.Merge(attg,attng)
		local attnc=attng:GetFirst()
		attset=attset | attnc:GetAttribute()
		lalv=lalv-3
	end

	Duel.SendtoGrave(attg,REASON_EFFECT)

	if attg and c then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
		if c:IsSummonable(true,nil,1) and Duel.SelectYesNo(tp,aux.Stringid(21400053,2)) then
			Duel.Summon(tp,c,true,nil,1)
		end
	end


end










