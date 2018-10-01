--衍生物唤灵祭
function c65050011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65050011.target)
	e1:SetOperation(c65050011.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,65050011)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c65050011.spcost)
	e2:SetTarget(c65050011.sptg)
	e2:SetOperation(c65050011.spop)
	c:RegisterEffect(e2)
end

function c65050011.spcosfil(c)
	return c:IsAbleToRemoveAsCost() and c:GetLevel()>0
end

function c65050011.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c65050011.spcosfil,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c65050011.spcosfil,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetLevel())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c65050011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,65050012,0,0x4011,0,0,e:GetLabel(),RACE_SPELLCASTER,ATTRIBUTE_LIGHT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c65050011.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,65050012,0,0x4011,0,0,e:GetLabel(),RACE_SPELLCASTER,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,65050012)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1)
	Duel.SpecialSummonComplete()
end


function c65050011.filter(c,e,tp,m1,ft)
	if bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c:IsCode(21105106) then return c:ritual_custom_condition(mg,ft) end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
	else
		return ft>-1 and mg:IsExists(c65050011.mfilterf,1,nil,tp,mg,c)
	end
end
function c65050011.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetRitualLevel,rc:GetLevel(),0,99,rc)
	else return false end
end

function c65050011.ritfil(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_TOKEN)
end

function c65050011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg0=Duel.GetRitualMaterial(tp)
		local mg1=mg0:Filter(c65050011.ritfil,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c65050011.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,mg1,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c65050011.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg0=Duel.GetRitualMaterial(tp)
	local mg1=mg0:Filter(c65050011.ritfil,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c65050011.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,mg1,ft)
	local tc=tg:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc:IsCode(21105106) then
			tc:ritual_custom_operation(mg)
			local mat=tc:GetMaterial()
			Duel.ReleaseRitualMaterial(mat)
		else
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,nil)
			end
			local mat=nil
			if ft>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:FilterSelect(tp,c65050011.mfilterf,1,1,nil,tp,mg,tc)
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),0,99,tc)
				mat:Merge(mat2)
			end
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end