--「02场」
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=65010011
local cm=_G["c"..m]
cm.card_code_list={65010001}
function cm.initial_effect(c)
	local e1=rsef.ACT(c) 
	local e2=rsef.FTO(c,EVENT_SUMMON_SUCCESS,{m,0},{1,0x1},nil,"de",LOCATION_FZONE,cm.con,nil,cm.tg,cm.op)
	local e3=rsef.FTO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,0x1},nil,"de",LOCATION_FZONE,cm.con,nil,cm.tg,cm.op)
	local e4=rsef.FTO(c,EVENT_FLIP_SUMMON_SUCCESS,{m,0},{1,0x1},nil,"de",LOCATION_FZONE,cm.con,nil,cm.tg,cm.op)
	local e5=rsef.FTO(c,EVENT_CHAIN_SOLVING,{m,1},nil,"sp","de",LOCATION_FZONE,cm.con2,nil,cm.sptg,cm.spop)
	--disable spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,1)
	e6:SetTarget(cm.splimit)
	c:RegisterEffect(e6)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	if c:IsCode(65010001) then return false end
	return targetp and targetp==e:GetHandlerPlayer()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.spfilter(c,e,tp)
	return c:IsCode(65010001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function cm.con(e,tp,eg)
	local f=function(c,p)
		return c:IsCode(65010001) and c:IsFaceup() and c:IsControler(p)
	end
	return eg:IsExists(f,1,nil,tp)
end
function cm.setfilter(c)
	return aux.IsCodeListed(c,65010001) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		if tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		elseif tc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		Duel.ConfirmCards(1-tp,g)
		if tc:IsPreviousLocation(LOCATION_GRAVE) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			tc:RegisterEffect(e1)
		end
	end
end