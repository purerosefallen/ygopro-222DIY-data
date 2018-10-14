--小女不才
function c12016023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12016023+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c12016023.target)
	e1:SetOperation(c12016023.activate)
	c:RegisterEffect(e1)
--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetTarget(c12016023.target1)
	e2:SetOperation(c12016023.activate1)
	c:RegisterEffect(e2)
end
c12016023.fit_monster={12016000}
function c12016023.dfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function c12016023.filter(c,e,tp,m,ft)
	if not c:IsSetCard(0xfb9) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	local dg=Duel.GetMatchingGroup(c12016023.dfilter,tp,LOCATION_DECK,0,nil)
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
			or dg:IsExists(c12016023.dlvfilter,1,nil,tp,mg,c)
	else
		return ft>-1 and mg:IsExists(c12016023.mfilterf,1,nil,tp,mg,dg,c)
	end
end
function c12016023.mfilterf(c,tp,mg,dg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
			or dg:IsExists(c12016023.dlvfilter,1,nil,tp,mg,rc,c)
	else return false end
end
function c12016023.dlvfilter(c,tp,mg,rc,mc)
	Duel.SetSelectedCard(Group.FromCards(c,mc))
	return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
end
function c12016023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c12016023.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c12016023.activate(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c12016023.filter),tp,LOCATION_HAND,0,1,1,nil,e,tp,m,ft)
	local tc=tg:GetFirst()
	if tc then
		local mat,dmat
		local mg=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		local dg=Duel.GetMatchingGroup(c12016023.dfilter,tp,LOCATION_DECK,0,nil)
		if ft>0 then
			local b1=dg:IsExists(c12016023.dlvfilter,1,nil,tp,mg,tc)
			local b2=mg:CheckWithSumEqual(Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(12016023,0))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				dmat=dg:FilterSelect(tp,c12016023.dlvfilter,1,1,nil,tp,mg,tc)
				Duel.SetSelectedCard(dmat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
				mat:Merge(dmat)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c12016023.mfilterf,1,1,nil,tp,mg,dg,tc)
			local b1=dg:IsExists(c12016023.dlvfilter,1,nil,tp,mg,tc,mat:GetFirst())
			Duel.SetSelectedCard(mat)
			local b2=mg:CheckWithSumEqual(Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
			if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(12016023,0))) and Duel.GetFlagEffect(tp,12016023)==0 then
				Duel.RegisterFlagEffect(tp,12016023,RESET_EVENT+RESET_PHASE+PHASE_END,0,1)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				dmat=dg:FilterSelect(tp,c12016023.dlvfilter,1,1,nil,tp,mg,tc,mat:GetFirst())
				mat:Merge(dmat)
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
				mat:Merge(mat2)
			else
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
				mat:Merge(mat2)
			end
		end
		tc:SetMaterial(mat)
		if dmat then
			mat:Sub(dmat)
			Duel.SendtoGrave(dmat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()  
	end
end
function c12016023.thfilter1(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:IsAbleToGrave()
end
function c12016023.thfilter2(c)
	return c:IsCode(12016000) and c:IsAbleToHand()
end
function c12016023.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12016023.thfilter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c12016023.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12016023.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local gc=Duel.SelectMatchingCard(tp,c12016023.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if gc:GetCount()>0 then
		Duel.SendtoGrave(gc,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12016023.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local tc=gc:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetLabel(tc:GetCode())
		e1:SetTarget(c12016023.sumlimit)
		e1:SetValue(c12016023.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
end

function c12016023.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function c12016023.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end