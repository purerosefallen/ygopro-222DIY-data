--泰拉魔物 远古教徒
if not pcall(function() require("expansions/script/c33310023") end) then require("script/c33310023") end
function c33310009.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--pendulum set/spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33310009,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,33310009)
	e1:SetTarget(c33310009.rptg)
	e1:SetOperation(c33310009.rpop)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33310009,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c33310009.spcon)
	e2:SetTarget(c33310009.sptg)
	e2:SetOperation(c33310009.spop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33310009,5))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c33310009.hncost)
	e3:SetTarget(c33310009.hntg)
	e3:SetOperation(c33310009.hnop)
	c:RegisterEffect(e3)
	if not c33310009.global_check then
		c33310009.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c33310009.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
c33310009.setcard="terraria"
function c33310009.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then
			tc:RegisterFlagEffect(33310009,RESET_EVENT+0x1f20000+RESET_PHASE+PHASE_END,0,1)
		elseif tc:IsLocation(LOCATION_EXTRA) then
			tc:RegisterFlagEffect(33310009,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function c33310009.rpfilter(c,e,tp)
	return c:IsCode(33310008) and (not c:IsForbidden()
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c33310009.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33310009.rpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c33310009.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33310009,6))
		local g=Duel.SelectMatchingCard(tp,c33310009.rpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		local op=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			op=Duel.SelectOption(tp,aux.Stringid(33310009,1),aux.Stringid(33310009,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(33310009,1))
		end
		if op==0 then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c33310009.spcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c.setcard=="terraria"
end
function c33310009.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33310009.spcfilter,1,nil,tp)
end
function c33310009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c33310009.thfilter1(c,tp,id)
	return c:IsType(TYPE_MONSTER) and c:GetFlagEffect(33310009)~=0
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(c33310009.thfilter2,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c33310009.thfilter2(c,code)
	return c:IsCode(code) and c:IsAbleToHand() and c.setcard=="terraria"
end
function c33310009.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(c33310009.thfilter1,tp,0x70,0x70,nil,tp,Duel.GetTurnCount())
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(33310009,4)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33310009,7))
			local cg=g:Select(tp,1,1,nil)
			Duel.HintSelection(cg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,c33310009.thfilter2,tp,LOCATION_DECK,0,1,1,nil,cg:GetFirst():GetCode())
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c33310009.cfilter(c)
	return c:IsCode(33310010,33310011,33310012,33310013) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial()
end
function c33310009.fcheck(c,sg,g,code,...)
	if not c:IsCode(code) then return false end
	if ... then
		g:AddCard(c)
		local res=sg:IsExists(c33310009.fcheck,1,g,sg,g,...)
		g:RemoveCard(c)
		return res
	else return true end
end
function c33310009.fselect(c,rc,tp,mg,sg,...)
	sg:AddCard(c)
	local tg=sg:Clone()
	tg:AddCard(rc)
	local res=false
	if sg:GetCount()<4 then
		res=mg:IsExists(c33310009.fselect,1,sg,rc,tp,mg,sg,...)
	elseif Duel.GetLocationCountFromEx(tp,tp,tg)>0 then
		local g=Group.CreateGroup()
		res=sg:IsExists(c33310009.fcheck,1,nil,sg,g,...)
	end
	sg:RemoveCard(c)
	return res
end
function c33310009.hnfilter(c,e,tp)
	return c:IsCode(33310014) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c33310009.hncost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c33310009.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local sg=Group.CreateGroup()
	if chk==0 then return c:IsAbleToRemoveAsCost() and 
	   mg:IsExists(c33310009.fselect,1,nil,c,tp,mg,sg,33310010,33310011,33310012,33310013) 
	end
	while sg:GetCount()<4 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=mg:FilterSelect(tp,c33310009.fselect,1,1,sg,c,tp,mg,sg,33310010,33310011,33310012,33310013)
		sg:Merge(g)
	end
	sg:AddCard(c)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c33310009.hntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33310009.hnfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c33310009.hnop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33310009.hnfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
	   g:GetFirst():CompleteProcedure()
	end
end
