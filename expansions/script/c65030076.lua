--雨后的寂寥街道
function c65030076.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--merry-go-round
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCost(c65030076.cost)
	e1:SetTarget(c65030076.tg)
	e1:SetOperation(c65030076.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(65030076,ACTIVITY_CHAIN,c65030076.chainfilter)
end
c65030076.card_code_list={65030086}
function c65030076.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return not (rc:IsType(TYPE_MONSTER) and not aux.IsCodeListed(rc,65030086))
end
function c65030076.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(65030076,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c65030076.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c65030076.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsType(TYPE_MONSTER) and not aux.IsCodeListed(rc,65030086)
end

function c65030076.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local num=Duel.GetMatchingGroupCount(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,num,tp,LOCATION_HAND)
	if num<=2 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,num+1)
	else
		Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,num)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c65030076.op(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetMatchingGroupCount(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)>0 and Duel.IsPlayerCanDraw(tp)) then return end
	local tgg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	local tgn=Duel.SendtoDeck(tgg,nil,2,REASON_EFFECT)
	if tgn>0 and Duel.IsPlayerCanDraw(tp) then
		Duel.ShuffleDeck(tp)
		if tgn<=2 then
			Duel.Draw(tp,tgn+1,REASON_EFFECT)
		else
			Duel.Draw(tp,tgn,REASON_EFFECT)
		end
		if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummon(tp)) then return end
		if Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,nil,e,0,tp,false,false) then
			local g=Duel.SelectMatchingCard(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,1,nil,e,0,tp,false,false)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		else
			local seeg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			Duel.ConfirmCards(1-tp,seeg)
		end
	end
end