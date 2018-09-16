--铁狼 伊森格林
function c69696904.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsType,TYPE_FLIP),1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69696904,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,696969041)
	e1:SetCondition(c69696904.spcon)
	e1:SetTarget(c69696904.sptg)
	e1:SetOperation(c69696904.spop)
	c:RegisterEffect(e1)
	--reveal
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69696904,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,696969042)
	e2:SetTarget(c69696904.retg)
	e2:SetOperation(c69696904.reop)
	c:RegisterEffect(e2)
end
function c69696904.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c69696904.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c69696904.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c69696904.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c69696904.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c69696904.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c69696904.refilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c69696904.refilter2(c,ty)
	return c:IsSSetable() and c:IsType(ty) 
end
function c69696904.refilter3(c)
	return c:IsSSetable() and c:IsType(TYPE_FIELD) 
end
function c69696904.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
end
function c69696904.reop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		local opt=e:GetLabel()
		local ty=TYPE_MONSTER 
		if opt==1 then ty=TYPE_SPELL end
		if opt==2 then ty=TYPE_TRAP end
		local ct=g:FilterCount(Card.IsType,nil,ty)
		if ct>0 then 
			local g1=Duel.GetMatchingGroup(c69696904.refilter1,tp,0,LOCATION_HAND,nil,e,tp)
			local g2=Duel.GetMatchingGroup(c69696904.refilter2,tp,0,LOCATION_HAND,nil,ty)
			local g3=Duel.GetMatchingGroup(c69696904.refilter3,tp,0,LOCATION_HAND,nil)
			if opt==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g1:GetCount()>0 then
				if Duel.SelectYesNo(tp,aux.Stringid(69696904,2)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
					local g11=g1:Select(tp,1,1,nil)
					local tc=g11:GetFirst()
					if tc then
						Duel.BreakEffect()
						Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
						Duel.ConfirmCards(1-tp,tc)
					end
				end
			elseif ((opt==1 and g3:GetCount()>0) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and g2:GetCount()>0 then
				if Duel.SelectYesNo(tp,aux.Stringid(69696904,3)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
					if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
						if opt==1 then
							local g22=g3:Select(tp,1,1,nil)
							local tc=g22:GetFirst()
							if tc then
								Duel.BreakEffect()
								Duel.SSet(tp,tc)
								Duel.ConfirmCards(1-tp,tc) 
							end
						end
					else
						local g22=g2:Select(tp,1,1,nil,ty)
						local tc=g22:GetFirst()
						if tc then
							Duel.BreakEffect()
							Duel.SSet(tp,tc)
							Duel.ConfirmCards(1-tp,tc) 
						end
					end
				end
			end
		else Duel.Damage(tp,1000,REASON_EFFECT) end
		Duel.ShuffleHand(1-tp)	   
	end
end