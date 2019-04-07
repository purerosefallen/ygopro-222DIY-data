--青蓝青色的踏步
function c65030080.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--merry-go-round
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCost(c65030080.cost)
	e1:SetTarget(c65030080.tg)
	e1:SetOperation(c65030080.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(65030080,ACTIVITY_CHAIN,c65030080.chainfilter)
end
c65030080.card_code_list={65030086}
function c65030080.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return not (rc:IsType(TYPE_MONSTER) and not aux.IsCodeListed(rc,65030086))
end
function c65030080.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(65030080,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c65030080.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c65030080.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsType(TYPE_MONSTER) and not aux.IsCodeListed(rc,65030086)
end

function c65030080.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local num=Duel.GetMatchingGroupCount(c65030080.opfil,tp,LOCATION_EXTRA,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,num,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65030080.opfil(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c65030080.remfil(c,g)
	return g:IsContains(c)
end
function c65030080.spfil(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65030080.op(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetMatchingGroupCount(Card.IsAbleToDeck,tp,LOCATION_EXTRA,0,nil)>0) then return end
	local tgg=Duel.GetMatchingGroup(c65030080.opfil,tp,LOCATION_EXTRA,0,nil)
	local tgn=Duel.SendtoDeck(tgg,nil,2,REASON_EFFECT)
	if tgn>0 then
		Duel.ShuffleDeck(tp)
		local g=Group.CreateGroup()
		if tgn<=2 then
			Duel.ConfirmDecktop(tp,tgn+1)
			g=Duel.GetDecktopGroup(tp,tgn+1)
		else
			Duel.ConfirmDecktop(tp,tgn)
			g=Duel.GetDecktopGroup(tp,tgn)
		end
		local teg=g:Filter(Card.IsType,nil,TYPE_PENDULUM)
		g:Remove(c65030080.remfil,nil,teg)
		Duel.SendtoExtraP(teg,tp,REASON_EFFECT)
		Duel.SendtoGrave(g,REASON_EFFECT)
		if not (Duel.GetLocationCountFromEx(tp)>0 and Duel.IsPlayerCanSpecialSummon(tp)) then return end
		if Duel.IsExistingMatchingCard(c65030080.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
			local g=Duel.SelectMatchingCard(tp,c65030080.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

